import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/pages/pixel/liked_by_page.dart';
import 'package:online_events/pages/pixel/user_post.dart';
import 'package:online_events/services/page_navigator.dart';
import '../../../components/animated_button.dart';
import '../../profile/profile_page.dart';
import '/theme/theme.dart';

class LikesCard extends StatelessWidget {
  const LikesCard({super.key, required this.post});

  final UserPostModel post;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          AnimatedButton(
            onTap: () {
              PageNavigator.navigateTo(LikedByPageDisplay(post: post));
            },
            childBuilder: (context, hover, pointerDown) {
              return Text(
                '${post.numberOfLikes} likerklikk',
                style: OnlineTheme.textStyle(),
              );
            },
          ),
        ],
      ),
    );
  }
}
