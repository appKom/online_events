import 'package:flutter/material.dart';
import 'package:online_events/pages/pixel/models/user_post.dart';
import '../../profile/profile_page.dart';
import '/theme/theme.dart';
import 'package:online_events/pages/pixel/pixel.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard(
      {super.key, required this.post, required this.onUnlikePost});

  final UserPostModel post;
  final Function(String, UserPostModel, String) onUnlikePost;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, 
        children: [
          Expanded(
            child: Text(
              '${post.username}: ${post.description}',
              style: OnlineTheme.textStyle(size: 16),
            ),
          ),
          // if (post.likedBy.contains(userProfile!.username.toString()))
          //   IconButton(
          //     padding: EdgeInsets.zero,
          //     iconSize: 24,
          //     icon: const Icon(Icons.heart_broken, color: OnlineTheme.red1),
          //     onPressed: () async {
          //       String userId = userProfile!.username.toString();
          //       await onUnlikePost(post.id, post, userId);
          //     },
          //   ),
        ],
      )
    ]);
  }
}
