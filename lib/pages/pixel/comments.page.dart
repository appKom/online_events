import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_events/pages/pixel/pixel.dart';
import 'package:online_events/pages/pixel/models/user_post.dart';
import 'package:online_events/pages/pixel/view_pixel_user.dart';
import 'package:online_events/pages/profile/profile_page.dart';

import '../../components/animated_button.dart';
import '../../components/online_header.dart';
import '../../components/online_scaffold.dart';
import '../../services/app_navigator.dart';
import '../../theme/theme.dart';
import '../home/profile_button.dart';

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
  }

  Future<void> postComment(
    String postId,
    UserPostModel post,
    String userName,
  ) async {
    if (_titleController.text.isNotEmpty) {
      try {
        final latestPost = await database.getDocument(
          databaseId: '658df78529d1a989a672',
          collectionId: '658dfd035a1c33a77037',
          documentId: postId,
        );
        List<dynamic> latestComments = latestPost.data['comments'];

        String newComment =
            '[$userName, ${_titleController.text}, ${DateTime.now()}]';
        latestComments.add(newComment);

        await database.updateDocument(
          databaseId: '658df78529d1a989a672',
          collectionId: '658dfd035a1c33a77037',
          documentId: postId,
          data: {
            'comments': latestComments,
          },
        );
        setState(() {
          widget.post.comments.add(newComment);
        });
        _titleController.clear();
      } catch (e) {
        showErrorTop("Error: $e");
      }
    } else {
      showErrorTop("Kommentaren må inneholde minst et symbol");
    }
  }

  OverlayEntry? _overlayEntry;

  void showErrorTop(String message) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 160,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              gradient: OnlineTheme.redGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 3), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  Future<void> deleteComment(int index) async {
    try {
      List<String> updatedComments = List<String>.from(widget.post.comments);
      updatedComments.removeAt(index);

      await database.updateDocument(
        databaseId: '658df78529d1a989a672',
        collectionId: '658dfd035a1c33a77037',
        documentId: widget.post.id,
        data: {
          'comments': updatedComments,
        },
      );

      setState(() {
        widget.post.comments = updatedComments;
      });
    } catch (e) {
      showErrorTop("Error: $e");
    }
  }

  String timeAgo(String dateTimeString) {
    final dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    final dateTimeUtc = dateFormat.parse(dateTimeString, true).toUtc();
    final nowUtc = DateTime.now().toUtc();
    final difference = nowUtc.difference(dateTimeUtc);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}t';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}uker';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnlineTheme.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: OnlineHeader.height(context) - 10),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 40,
                          ),
                          onPressed: () => PageNavigator.navigateTo(
                              const PixelPageDisplay()),
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
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.post.comments.length,
                      itemBuilder: (context, index) {
                        String comment = widget.post.comments[index];

                        if (comment.startsWith('[')) {
                          comment = comment.substring(1);
                        }
                        if (comment.endsWith(']')) {
                          comment = comment.substring(0, comment.length - 1);
                        }

                        int firstCommaIndex = comment.indexOf(',');
                        int lastCommaIndex = comment.lastIndexOf(',');

                        String username =
                            comment.substring(0, firstCommaIndex).trim();
                        String commentText = comment
                            .substring(firstCommaIndex + 1, lastCommaIndex)
                            .trim();
                        String timeAgoString =
                            comment.substring(lastCommaIndex + 1).trim();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedButton(onTap: () {
                                    PageNavigator.navigateTo(
                                        ViewPixelUserDisplay(
                                      userName: username,
                                    ));
                                  }, childBuilder:
                                      (context, hover, pointerDown) {
                                    return ClipOval(
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Image.network(
                                          'https://cloud.appwrite.io/v1/storage/buckets/658996fac01c08570158/files/$username/view?project=65706141ead327e0436a&mode=public',
                                          fit: BoxFit.cover,
                                          height: 50,
                                          errorBuilder:
                                              (context, exception, stackTrace) {
                                            return Image.asset(
                                              'assets/images/default_profile_picture.png',
                                              fit: BoxFit.cover,
                                              height: 50,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '$username:',
                                              style: OnlineTheme.textStyle(
                                                  size: 16, weight: 5),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              timeAgo(timeAgoString),
                                              style: OnlineTheme.textStyle(
                                                  size: 14,
                                                  color: OnlineTheme.gray8),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          commentText,
                                          style:
                                              OnlineTheme.textStyle(size: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (userProfile!.ntnuUsername == username)
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: OnlineTheme.white),
                                      onPressed: () async {
                                        await deleteComment(index);
                                      },
                                    ),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 80 + MediaQuery.of(context).padding.bottom,
              ),
              color: OnlineTheme.background,
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
                maxLength: 350,
                onFieldSubmitted: (value) {
                  postComment(
                      widget.post.id, widget.post, userProfile!.username);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentPageDisplay extends StaticPage {
  const CommentPageDisplay({super.key, required this.post});

  final UserPostModel post;

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
      buttons: const [
        ProfileButton(),
      ],
    );
  }

  @override
  Widget content(BuildContext context) {
    return CommentPage(post: post);
  }
}
