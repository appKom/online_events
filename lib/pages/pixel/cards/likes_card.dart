import 'package:flutter/material.dart';
import 'package:online_events/pages/pixel/user_post.dart';
import '/theme/theme.dart';


class LikesCard extends StatelessWidget {
  const LikesCard({super.key, required this.post});

  final UserPostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      child: Text(
        '${post.numberOfLikes} likerklikk',
        style: OnlineTheme.textStyle(),
      ),
    );
  }
}
