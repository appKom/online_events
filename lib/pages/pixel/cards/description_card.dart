import 'package:flutter/material.dart';

import '/pages/pixel/models/user_post.dart';
import '/theme/theme.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({super.key, required this.post, required this.onUnlikePost});

  final UserPostModel post;
  final Function(String, UserPostModel, String) onUnlikePost;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '${post.username}: ${post.description}',
              style: OnlineTheme.textStyle(size: 16),
            ),
          ),
        ],
      )
    ]);
  }
}
