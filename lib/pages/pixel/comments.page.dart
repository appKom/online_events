import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_events/pages/pixel/pixel.dart';
import 'package:online_events/pages/pixel/user_post.dart';
import 'package:online_events/pages/profile/profile_page.dart';

import '../../components/animated_button.dart';
import '../../components/navbar.dart';
import '../../components/online_header.dart';
import '../../components/online_scaffold.dart';
import '../../services/app_navigator.dart';
import '../../theme/theme.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key, required this.post});

  final UserPostModel post;

  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  final TextEditingController _titleController = TextEditingController();
  late Databases database;
  List<dynamic> sortedComments = [];

  @override
  void initState() {
    super.initState();
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('65706141ead327e0436a');
    database = Databases(client);
    print(widget.post.comments);
  }

  Future<void> postComment(
    String postId,
    UserPostModel post,
    String userName,
  ) async {
    try {
      final latestPost = await database.getDocument(
        databaseId: '658df78529d1a989a672',
        collectionId: '658dfd035a1c33a77037',
        documentId: postId,
      );
      List<dynamic> latestComments = latestPost.data['comments'];

      latestComments.addAll([
        '[$userName, ${_titleController.text}, ${DateTime.now().toString()}]'
      ]);

      await database.updateDocument(
        databaseId: '658df78529d1a989a672',
        collectionId: '658dfd035a1c33a77037',
        documentId: postId,
        data: {
          'comments': latestComments,
        },
      );
      print('Comment posted successfully');
      _titleController.clear();
      setState(() {});
    } catch (e) {
      print("Error posting comment: $e");
    }
  }

  Future<void> deleteComment(int index) async {
      try {
        List<String> updatedComments = List<String>.from(widget.post.comments);
        updatedComments
            .removeAt(index); 

        await database.updateDocument(
          databaseId: '658df78529d1a989a672',
          collectionId: '658dfd035a1c33a77037',
          documentId: widget.post.id,
          data: {
            'comments': updatedComments,
          },
        );
        print('Comment deleted successfully');

        setState(() {
          widget.post.comments = updatedComments;
        });
      } catch (e) {
        print("Error deleting comment: $e");
      }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnlineTheme.background,
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: OnlineHeader.height(context) + 20),
                Row(children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () =>
                        PageNavigator.navigateTo(const PixelPageDisplay()),
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Center(
                    child: Text(
                      'Kommentarer',
                      style: OnlineTheme.textStyle(size: 25, weight: 5),
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 30,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.post.comments.length,
                  itemBuilder: (context, index) {
                    List<String> commentParts =
                        widget.post.comments[index].split(', ');

                    String username = commentParts[0];
                    if (username.startsWith('[')) {
                      username = username.substring(1);
                    }

                    if (commentParts.length >= 3) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipOval(
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.network(
                                    'https://cloud.appwrite.io/v1/storage/buckets/658996fac01c08570158/files/$username/view?project=65706141ead327e0436a&mode=public',
                                    fit: BoxFit.cover,
                                    height: 50,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset(
                                        'assets/images/default_profile_picture.png',
                                        fit: BoxFit.cover,
                                        height: 30,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text('$username:',
                                  style: OnlineTheme.textStyle(
                                      size: 16, weight: 5)),
                              const SizedBox(width: 8),
                              Text(commentParts[1],
                                  style: OnlineTheme.textStyle(size: 14)),
                              if (userProfile!.ntnuUsername == widget.post.username)
                              const Spacer(),
                              if (userProfile!.ntnuUsername == widget.post.username)
                              AnimatedButton(
                                  onTap: () {},
                                  childBuilder: (context, hover, pointerDown) {
                                    return IconButton(
                                      padding: EdgeInsets.zero,
                                      iconSize: 24,
                                      icon: const Icon(Icons.delete,
                                          color: OnlineTheme.white),
                                      onPressed: () async {
                                        await deleteComment(index);
                                      },
                                    );
                                  }),
                            ],
                          ),
                          const Divider()
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: TextFormField(
              controller: _titleController,
              style: OnlineTheme.textStyle(color: OnlineTheme.white),
              decoration: InputDecoration(
                labelText: 'Skriv en kommentar',
                labelStyle: OnlineTheme.textStyle(color: OnlineTheme.white),
                hintStyle: OnlineTheme.textStyle(color: OnlineTheme.white),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: OnlineTheme.white),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: OnlineTheme.white),
                ),
              ),
              onFieldSubmitted: (value) {
                postComment(widget.post.id, widget.post, userProfile!.username);
              },
            ),
          ),
          SizedBox(height: Navbar.height(context) + 10),
        ],
      ),
    );
  }
}

class CommentPageDisplay extends StaticPage {
  const CommentPageDisplay({super.key, required this.post});

  final UserPostModel post;

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return CommentPage(post: post);
  }
}
