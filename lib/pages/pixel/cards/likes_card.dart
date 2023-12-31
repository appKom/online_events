import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/pages/pixel/liked_by_page.dart';
import 'package:online_events/pages/pixel/models/user_post.dart';
import 'package:online_events/services/page_navigator.dart';
import '../../../components/animated_button.dart';
import '../../profile/profile_page.dart';
import '/theme/theme.dart';

class LikesCard extends StatefulWidget {
  final UserPostModel post;
  final Function(String, UserPostModel, String) onUnlikePost;
  final Function(String, UserPostModel, String) onLikePost;

  const LikesCard({
    Key? key,
    required this.post,
    required this.onUnlikePost,
    required this.onLikePost,
  }) : super(key: key);

  @override
  LikesCardState createState() => LikesCardState();
}

class LikesCardState extends State<LikesCard> {
  late bool isLiked;
  late int numberOfLikes;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.likedBy.contains(userProfile!.username);
    numberOfLikes = widget.post.numberOfLikes;
  }

  void handleLike() async {
    setState(() {
      isLiked = true;
      numberOfLikes++;
    });

    try {
      String userId = userProfile!.username.toString();
      await widget.onLikePost(widget.post.id, widget.post, userId);
    } catch (error) {
      setState(() {
        isLiked = false;
        numberOfLikes--;
      });
    }
  }

  void handleUnlike() async {
    setState(() {
      isLiked = false;
      numberOfLikes--;
    });

    try {
      String userId = userProfile!.username.toString();
      await widget.onUnlikePost(widget.post.id, widget.post, userId);
    } catch (error) {
      setState(() {
        isLiked = true;
        numberOfLikes++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          AnimatedButton(
            onTap: () {
              PageNavigator.navigateTo(LikedByPageDisplay(post: widget.post));
            },
            childBuilder: (context, hover, pointerDown) {
              return Text(
                '$numberOfLikes likerklikk',
                style: OnlineTheme.textStyle(),
              );
            },
          ),
          const SizedBox(width: 10),
          AnimatedButton(
            onTap: isLiked ? handleUnlike : handleLike,
            childBuilder: (context, hover, pointerDown) {
              return Image.asset(isLiked
                  ? 'assets/images/heart_filled.png'
                  : 'assets/images/heart_not_filled.png');
            },
          ),
        ],
      ),
    );
  }
}
