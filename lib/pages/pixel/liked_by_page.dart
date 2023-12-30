import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:online_events/pages/pixel/user_post.dart';

import '../../components/animated_button.dart';
import '../../components/online_header.dart';
import '../../components/online_scaffold.dart';
import '../../services/page_navigator.dart';
import '../../theme/theme.dart';
import 'pixel.dart';
import 'pixel_user_class.dart';
import 'view_pixel_user.dart';

class LikeByPage extends StatefulWidget {
  const LikeByPage({super.key, required this.post});

  final UserPostModel post;

  @override
  LikedByPageState createState() => LikedByPageState();
}

class LikedByPageState extends State<LikeByPage> {
  late Databases database;
  List<PixelUserClass> users = [];

  @override
  void initState() {
    super.initState();
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('65706141ead327e0436a');
    database = Databases(client);

    fetchLikedByUsers();
  }

  void fetchLikedByUsers() async {
    for (var userName in widget.post.likedBy) {
      var result = await database.getDocument(
          collectionId: '658df9d98bf50c887791',
          documentId: userName,
          databaseId: '658df9c7899c43cd556f');
      var user = PixelUserClass.fromJson(result.data);
      setState(() {
        users.add(user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnlineTheme.background,
      body: Column(children: [
        SizedBox(height: OnlineHeader.height(context) + 20),
        Center(
          child: Row(
            children: [
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
                width: 5,
              ),
              Center(
                child: Text(
                  'Likt av',
                  style: OnlineTheme.textStyle(size: 25, weight: 5),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedButton(onTap: () {
                            PageNavigator.navigateTo(ViewPixelUserDisplay(
                              userName: users[index].userName,
                            ));
                          }, childBuilder: (context, hover, pointerDown) {
                            return ClipOval(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.network(
                                  'https://cloud.appwrite.io/v1/storage/buckets/658996fac01c08570158/files/${users[index].userName}/view?project=65706141ead327e0436a&mode=public',
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${users[index].userName}',
                                  style: OnlineTheme.textStyle(
                                      size: 16, weight: 5),
                                ),
                                Text(
                                  '${users[index].firstName} ${users[index].lastName}',
                                  style: OnlineTheme.textStyle(size: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}

class LikedByPageDisplay extends StaticPage {
  const LikedByPageDisplay({super.key, required this.post});

  final UserPostModel post;

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return LikeByPage(post: post);
  }
}
