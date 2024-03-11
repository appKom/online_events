import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../components/animated_button.dart';
import '../../../theme/theme.dart';
import 'poll_class.dart';

class OnlinePolls extends StatefulWidget {
  const OnlinePolls({super.key});

  @override
  OnlinePollsState createState() => OnlinePollsState();
}

class OnlinePollsState extends State<OnlinePolls> {
  late Databases database;
  int? selectedOption;
  List<PollClass> polls = [];

  @override
  void initState() {
    super.initState();
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(dotenv.env['PROJECT_ID']);
    database = Databases(client);
  }

  Future<List<PollClass>> getPolls() async {
    final response = await database.listDocuments(
        collectionId: dotenv.env['POLL_COLLECTION_ID']!,
        databaseId: dotenv.env['POLL_DATABASE_ID']!);

    List<PollClass> polls =
        response.documents.map((doc) => PollClass.fromJson(doc.data)).toList();

    polls.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return polls;
  }

  Future<void> submitVote() async {
    if (selectedOption == null) return print('failed to submit vote');

    final PollClass currentPoll = polls.first;

    final String userId = '123';

    // Check if the user has already voted to prevent duplicate votes
    if (!currentPoll.votes.contains(userId)) {
      currentPoll.votes.add(userId);

      try {
        await database.updateDocument(
          collectionId: dotenv.env['POLL_COLLECTION_ID']!,
          databaseId: dotenv.env['POLL_DATABASE_ID']!,
          documentId: currentPoll.id,
          data: {
            'votes': currentPoll.votes,
          },
        );
        print("Vote submitted successfully");
      } catch (e) {
        print("Failed to submit vote: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PollClass>>(
      future: getPolls(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: const CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data != null && snapshot.data!.isNotEmpty) {
          PollClass latestPoll = snapshot.data!.first;
          List<String> options = List<String>.from(latestPoll.choices);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  latestPoll.question,
                  style: OnlineTheme.textStyle(size: 20, weight: 5),
                ),
              ),
              ...options.asMap().entries.map((entry) {
                int idx = entry.key;
                String opt = entry.value;
                return ListTile(
                  title: Text(
                    opt,
                    style: OnlineTheme.textStyle(),
                  ),
                  leading: Radio<int>(
                    value: idx,
                    groupValue: selectedOption,
                    onChanged: (int? value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                );
              }),
              if (selectedOption != null)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: 120,
                    child: AnimatedButton(
                      onTap: () {
                        setState(() {
                          selectedOption = null;
                        });
                        submitVote();
                      },
                      childBuilder: (context, hover, pointerDown) {
                        return Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: OnlineTheme.yellow.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(5.0),
                            border: const Border.fromBorderSide(BorderSide(
                                color: OnlineTheme.yellow, width: 2)),
                          ),
                          child: Text(
                            'Send Inn!',
                            style: OnlineTheme.textStyle(
                              weight: 5,
                              color: OnlineTheme.yellow,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        } else {
          return const SizedBox(
            height: 100,
            width: 100,
          );
        }
      },
    );
  }
}
