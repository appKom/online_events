import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../home/profile_button.dart';
import '/components/animated_button.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/pages/pixel/models/user_post.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';
import 'models/pixel_user_class.dart';
import 'pixel.dart';
import 'view_pixel_user.dart';

class LikeByPage extends StatefulWidget {
  const LikeByPage({
    super.key,
    required this.post,
  });

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
    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject(dotenv.env['PROJECT_ID']);
    database = Databases(client);

    fetchLikedByUsers();
  }

  void fetchLikedByUsers() async {
    for (var userName in widget.post.likedBy) {
      var result = await database.getDocument(
          collectionId: dotenv.env['USER_COLLECTION_ID']!,
          documentId: userName,
          databaseId: dotenv.env['USER_DATABASE_ID']!);
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
                onPressed: () => PageNavigator.navigateTo(const PixelPageDisplay()),
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
                                  'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['USER_BUCKET_ID']}/files/${users[index].userName}/preview?width=75&height=75&project=${dotenv.env['PROJECT_ID']}&mode=public',
                                  fit: BoxFit.cover,
                                  height: 50,
                                  errorBuilder: (context, exception, stackTrace) {
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
                                  style: OnlineTheme.textStyle(size: 16, weight: 5),
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
  const LikedByPageDisplay({
    super.key,
    required this.post,
  });

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
    return LikeByPage(
      post: post,
    );
  }
}
