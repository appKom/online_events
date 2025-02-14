import 'package:flutter/material.dart';

import '../pixel.dart';
import '/components/animated_button.dart';
import '/core/client/client.dart';
import '/pages/pixel/liked_by_page.dart';
import '/pages/pixel/models/user_post.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

class LikesCard extends StatefulWidget {
  final UserPostModel post;
  final Function(String, UserPostModel, String) onUnlikePost;
  final Function(String, UserPostModel, String) onLikePost;
  final Function(String) onDeletePost;

  const LikesCard({
    super.key,
    required this.post,
    required this.onUnlikePost,
    required this.onLikePost,
    required this.onDeletePost,
  });

  @override
  LikesCardState createState() => LikesCardState();
}

class LikesCardState extends State<LikesCard> with SingleTickerProviderStateMixin {
  late bool isLiked;
  late int numberOfLikes;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    final userProfile = Client.userCache.value;

    isLiked = widget.post.likedBy.contains(userProfile?.username);
    numberOfLikes = widget.post.numberOfLikes;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void handleLike() async {
    _animationController.forward().then((_) => _animationController.reverse());
    if (isLiked == false) {
      setState(() {
        isLiked = true;
        numberOfLikes++;
      });
    }

    try {
      final userProfile = Client.userCache.value;
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
      final userProfile = Client.userCache.value;
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
    var screenWidth = MediaQuery.of(context).size.width;
    final userProfile = Client.userCache.value;
    return Column(
      children: [
        GestureDetector(
          onDoubleTap: () {
            handleLike();
          },
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.network(
                widget.post.imageLink,
                width: screenWidth,
                fit: BoxFit.cover,
              ),
              if (widget.post.username == userProfile!.username)
                AnimatedButton(
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: OnlineTheme.current.fg,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 24,
                        icon: Icon(Icons.delete, color: OnlineTheme.current.muted),
                        onPressed: () async {
                          try {
                            widget.onDeletePost(widget.post.id);
                            print('Image deleted successfully');
                            AppNavigator.navigateToPage(const DummyDisplay2());
                          } catch (e) {
                            print("Error deleting image: $e");
                          }
                        },
                      ),
                    );
                  },
                ),
              ScaleTransition(
                scale: _animation,
                child: Icon(Icons.favorite, size: 250, color: Colors.red.withValues(alpha: _animation.value)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
          child: Row(
            children: [
              AnimatedButton(
                onTap: () {
                  AppNavigator.navigateToPage(LikedByPageDisplay(
                    post: widget.post,
                  ));
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
                  return Image.asset(isLiked ? 'assets/images/heart_filled.png' : 'assets/images/heart_not_filled.png');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
