import 'dart:io';
import 'dart:math';

import 'package:appwrite/models.dart' as io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:intl/intl.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/main.dart';
import 'package:online_events/pages/pixel/cards/description_card.dart';
import 'package:online_events/pages/pixel/cards/image_card.dart';
import 'package:online_events/pages/pixel/cards/not_logged_in_card.dart';
import 'package:online_events/pages/pixel/comments.page.dart';
import 'package:online_events/pages/pixel/info_page_pixel.dart';
import 'package:online_events/pages/pixel/cards/likes_card.dart';
import 'package:online_events/pages/pixel/view_pixel_user.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import '../../components/animated_button.dart';
import '../../components/online_scaffold.dart';
import '../../components/separator.dart';
import '../../services/app_navigator.dart';
import '../../theme/theme.dart';
import '../login/auth_web_view_page.dart';
import 'pixel_user_class.dart';
import 'upload_page.dart';
import 'user_post.dart';

class PixelPage extends StatefulWidget {
  const PixelPage({super.key});

  @override
  PixelPageState createState() => PixelPageState();
}

class PixelPageState extends State<PixelPage> {
  late Storage storage;
  late Databases database;
  bool showHeartAnimation = false;

  @override
  void initState() {
    super.initState();
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('65706141ead327e0436a');
    database = Databases(client);
  }

  Future<List<UserPostModel>> getUserPosts() async {
    final response = await database.listDocuments(
        collectionId: '658dfd035a1c33a77037',
        databaseId: '658df78529d1a989a672');

    List<UserPostModel> posts = response.documents
        .map((doc) => UserPostModel.fromJson(doc.data))
        .toList();

    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return posts;
  }

  String formatRelativeTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()}w';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}t';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}min';
    } else {
      return '${difference.inSeconds}s';
    }
  }

  Future<void> likePost(
      String postId, UserPostModel post, String userId) async {
    if (!post.likedBy.contains(userId)) {
      try {
        await database.updateDocument(
          databaseId: '658df78529d1a989a672',
          collectionId: '658dfd035a1c33a77037',
          documentId: postId,
          data: {
            'number_of_likes': post.numberOfLikes + 1,
            'liked_by': [...post.likedBy, userId],
          },
        );
        print('Likes incremented successfully');
      } catch (e) {
        print("Error incrementing likes: $e");
      }
    }
  }

  Future<void> unlikePost(
      String postId, UserPostModel post, String userId) async {
    if (post.likedBy.contains(userId)) {
      try {
        List<String> updatedLikedBy = List<String>.from(post.likedBy)
          ..remove(userId);

        await database.updateDocument(
          databaseId: '658df78529d1a989a672',
          collectionId: '658dfd035a1c33a77037',
          documentId: postId,
          data: {
            'number_of_likes': post.numberOfLikes - 1,
            'liked_by': updatedLikedBy,
          },
        );
        print('Post unliked successfully');
        setState(() {});
      } catch (e) {
        print("Error unliking post: $e");
      }
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await database.deleteDocument(
        databaseId: '658df78529d1a989a672',
        collectionId: '658dfd035a1c33a77037',
        documentId: postId,
      );
      print('Post deleted successfully');

      setState(() {});
    } catch (e) {
      print("Error deleting post: $e");
    }
  }

  Future<void> refreshPage() async {
    getUserPosts();

    setState(() {
      //
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);
    if (loggedIn) {
      return Scaffold(
        backgroundColor: OnlineTheme.background,
        body: RefreshIndicator(
          onRefresh: refreshPage,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: OnlineHeader.height(context) + 20),
              Center(
                child: Row(
                  children: [
                    Text(
                      'Pixel',
                      style: OnlineTheme.textStyle(size: 30, weight: 7)
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    AnimatedButton(
                        onTap: () => AppNavigator.navigateToRoute(
                              InfoPagePixel(),
                              additive: true,
                            ),
                        childBuilder: (context, hover, pointerDown) {
                          return const Icon(
                            Icons.info_outline,
                            color: OnlineTheme.white,
                          );
                        })
                  ],
                ),
              ),
              Flexible(
                child: FutureBuilder<List<UserPostModel>>(
                  future: getUserPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No posts found');
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        UserPostModel post = snapshot.data![index];

                        String nameBeforeComma = post.username;

                        String nameAfterLastComma =
                            '${post.firstName} ${post.lastName}';

                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                decoration: const BoxDecoration(
                                    color: OnlineTheme.background),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    AnimatedButton(onTap: () {
                                      PageNavigator.navigateTo(
                                          ViewPixelUserDisplay(
                                        userName: nameBeforeComma,
                                      ));
                                    }, childBuilder:
                                        (context, hover, pointerDown) {
                                      return ClipOval(
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Image.network(
                                            'https://cloud.appwrite.io/v1/storage/buckets/658996fac01c08570158/files/$nameBeforeComma/view?project=65706141ead327e0436a&mode=public',
                                            fit: BoxFit.cover,
                                            height: 50,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
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
                                                height: 50,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      nameAfterLastComma,
                                      style: OnlineTheme.textStyle(weight: 4),
                                    ),
                                    const Spacer(),
                                    Text(
                                      formatRelativeTime(post.createdAt),
                                      style: OnlineTheme.textStyle(weight: 4),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ImageCard(
                                  post: post,
                                  onLikePost: (String postId,
                                      UserPostModel post, String userId) {
                                    likePost(postId, post, userId);
                                  },
                                  onDeletePost: (String postId) {
                                    deletePost(postId);
                                  }),
                              const SizedBox(
                                height: 4,
                              ),
                              LikesCard(post: post),
                              const SizedBox(
                                height: 4,
                              ),
                              DescriptionCard(
                                post: post,
                                onUnlikePost: (String postId,
                                    UserPostModel post, String userId) {
                                  unlikePost(postId, post, userId);
                                },
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  AnimatedButton(
                                    onTap: () => PageNavigator.navigateTo(
                                        CommentPageDisplay(post: post)),
                                    childBuilder:
                                        (context, hover, pointerDown) {
                                      return Text(
                                        'Vis kommentarer',
                                        style: OnlineTheme.textStyle(
                                            color: OnlineTheme.gray10),
                                      );
                                    },
                                  ),
                                  const Spacer(),
                                ],
                              ),
                              const Separator(margin: 20),
                            ]);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20), // Add padding at the bottom for the button
                child: AnimatedButton(
                  onTap: () {
                    PageNavigator.navigateTo(const UploadPageDisplay());
                  },
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: OnlineTheme.purpleGradient,
                        borderRadius: OnlineTheme.eventButtonRadius,
                      ),
                      child: Center(
                        child: Text(
                          'Last opp',
                          style: OnlineTheme.textStyle(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: Navbar.height(context) + 10),
            ],
          ),
        ),
      );
    } else {
      return const NotLoggedInCard();
    }
  }
}

class PixelPageDisplay extends StaticPage {
  const PixelPageDisplay({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const PixelPage();
  }
}

class DummyDisplay2 extends StaticPage {
  const DummyDisplay2({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const PixelPage();
  }
}
