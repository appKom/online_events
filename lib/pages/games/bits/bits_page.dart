import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '/components/online_scaffold.dart';
import '/pages/games/bits/bits_home_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'bits_model.dart';

class Bits extends StatefulWidget {
  const Bits({super.key});

  @override
  State<StatefulWidget> createState() => BitsState();
}

class BitsState extends State<Bits> {
  late final Client client;
  late final Databases database;
  List<BitsModel> bitsPages = [];
  int index = 0;

  @override
  void initState() {
    super.initState();
    initializeAppwrite();
    fetchDocuments();
  }

  void initializeAppwrite() {
    client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject(dotenv.env['PROJECT_ID'] ?? '');
    database = Databases(client);
  }

  Future<void> fetchDocuments() async {
    try {
      final result = await database.listDocuments(
        collectionId: '65d4f949a087960c15bd',
        databaseId: '65d4f93e339d6b1b4a55',
        // queries: [
        //   Query.orderDesc('createdAt'),
        // ]
      );
      final documents = result.documents;
      setState(() {
        bitsPages = documents.map((doc) => BitsModel.fromJson(doc.data)).toList();
      });
    } catch (e) {
      print("Error fetching documents: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    const background = Color.fromARGB(255, 225, 10, 189);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            OnlineTheme.background,
            background,
          ],
        ),
      ),
      child: Row(
        children: [
          // Left GestureDetector
          Expanded(
            child: GestureDetector(
              onTap: previous,
              child: Container(color: Colors.transparent),
            ),
          ),

          // Main content
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.only(
                left: padding.left,
                right: padding.right,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 150),
                  Text(
                    bitsPages[index].header,
                    style: OnlineTheme.textStyle(size: 33, weight: 7),
                  ),
                  const SizedBox(height: 20),
                  const ClipRRect(child: SizedBox(height: 80)),
                  Text(
                    bitsPages[index].body,
                    style: OnlineTheme.textStyle(size: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ClipRRect(
                    borderRadius: OnlineTheme.buttonRadius,
                    child: Image.network(
                      bitsPages[index].imageSource,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: next,
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  // int index = 0;

  void next() {
    setState(() {
      index++;
      index = index.clamp(0, bitsPages.length - 1);
    });
  }

  void previous() {
    if (index == 0) {
      AppNavigator.navigateToPage(const BitsHomePage());
    }
    setState(() {
      index--;
    });
  }
}

class BitsGame extends StaticPage {
  const BitsGame({super.key});

  @override
  Widget content(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: Bits()),
      ],
    );
  }
}
