import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/main.dart';
import '/pages/pixel/cards/description_card.dart';
import '/pages/pixel/cards/likes_card.dart';
import '/pages/pixel/cards/not_logged_in_card.dart';
import '/pages/pixel/cards/who_posted_card.dart';
import '/pages/pixel/comments.page.dart';
import '/pages/pixel/info_page_pixel.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'models/user_post.dart';
import 'upload_page.dart';

class PixelPage extends StatefulWidget {
  const PixelPage({super.key});

  @override
  PixelPageState createState() => PixelPageState();
}

class PixelPageState extends State<PixelPage> {
  late Storage storage;
  late Databases database;
  bool showHeartAnimation = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject(dotenv.env['PROJECT_ID']);
    database = Databases(client);
  }

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

  Future<List<UserPostModel>> getUserPosts() async {
    final response = await database.listDocuments(
        collectionId: dotenv.env['PIXEL_COLLECTION_ID']!, databaseId: dotenv.env['PIXEL_DATABASE_ID']!);

    List<UserPostModel> posts = response.documents.map((doc) => UserPostModel.fromJson(doc.data)).toList();

    posts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return posts;
  }

  String formatRelativeTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()}uker';
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

  Future<void> likePost(String postId, UserPostModel post, String userName) async {
    if (!post.likedBy.contains(userName)) {
      try {
        await database.updateDocument(
          databaseId: dotenv.env['PIXEL_DATABASE_ID']!,
          collectionId: dotenv.env['PIXEL_COLLECTION_ID']!,
          documentId: postId,
          data: {
            'number_of_likes': post.numberOfLikes + 1,
            'liked_by': [...post.likedBy, userName],
          },
        );
      } catch (e) {
        showErrorTop("Error: $e");
      }
    }
  }

  Future<void> unlikePost(String postId, UserPostModel post, String userId) async {
    if (post.likedBy.contains(userId)) {
      try {
        List<String> updatedLikedBy = List<String>.from(post.likedBy)..remove(userId);

        await database.updateDocument(
          databaseId: dotenv.env['PIXEL_DATABASE_ID']!,
          collectionId: dotenv.env['PIXEL_COLLECTION_ID']!,
          documentId: postId,
          data: {
            'number_of_likes': post.numberOfLikes - 1,
            'liked_by': updatedLikedBy,
          },
        );
      } catch (e) {
        showErrorTop("Error: $e");
      }
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await database.deleteDocument(
        databaseId: dotenv.env['PIXEL_DATABASE_ID']!,
        collectionId: dotenv.env['PIXEL_COLLECTION_ID']!,
        documentId: postId,
      );

      if (mounted) {
        setState(() {});
      }
      AppNavigator.navigateToPage(const DummyDisplay2());
    } catch (e) {
      showErrorTop("Error: $e");
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
                      style: OnlineTheme.textStyle(size: 30, weight: 7).copyWith(color: Colors.white),
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
                        String nameAfterLastComma = '${post.firstName} ${post.lastName}';

                        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                              height: 50,
                              decoration: const BoxDecoration(color: OnlineTheme.background),
                              child: WhoPostedCard(
                                  post: post,
                                  nameBeforeComma: nameBeforeComma,
                                  nameAfterLastComma: nameAfterLastComma,
                                  formatDate: formatRelativeTime)),
                          const SizedBox(
                            height: 10,
                          ),
                          // ImageCard(
                          //     post: post,
                          //     onLikePost: (String postId,
                          //         UserPostModel post, String userName) {
                          //       likePost(postId, post, userName);
                          //     },
                          // onDeletePost: (String postId) {
                          //   deletePost(postId);
                          // }),
                          const SizedBox(
                            height: 4,
                          ),
                          LikesCard(
                              post: post,
                              onDeletePost: (String postId) {
                                deletePost(postId);
                              },
                              onUnlikePost: (String postId, UserPostModel post, String userId) {
                                unlikePost(postId, post, userId);
                              },
                              onLikePost: (String postId, UserPostModel post, String userId) {
                                likePost(postId, post, userId);
                              }),
                          const SizedBox(
                            height: 4,
                          ),
                          DescriptionCard(
                            post: post,
                            onUnlikePost: (String postId, UserPostModel post, String userId) {
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
                                onTap: () => AppNavigator.navigateToPage(CommentPageDisplay(post: post)),
                                childBuilder: (context, hover, pointerDown) {
                                  return Text(
                                    'Vis kommentarer',
                                    style: OnlineTheme.textStyle(color: OnlineTheme.gray9),
                                  );
                                },
                              ),
                              const Spacer(),
                            ],
                          ),
                          const Separator(margin: 10),
                        ]);
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25, vertical: 20), // Add padding at the bottom for the button
                child: AnimatedButton(
                  onTap: () {
                    AppNavigator.navigateToPage(const UploadPageDisplay());
                  },
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: OnlineTheme.purpleGradient,
                        borderRadius: OnlineTheme.buttonRadius,
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
  Widget content(BuildContext context) {
    return const PixelPage();
  }
}

class DummyDisplay2 extends StaticPage {
  const DummyDisplay2({super.key});

  @override
  Widget content(BuildContext context) {
    return const PixelPage();
  }
}
