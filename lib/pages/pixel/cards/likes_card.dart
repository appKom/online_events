import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/pages/pixel/liked_by_page.dart';
import 'package:online_events/pages/pixel/models/user_post.dart';
import 'package:online_events/services/page_navigator.dart';
import '../../../components/animated_button.dart';
import '../../profile/profile_page.dart';
import '../pixel.dart';
import '/theme/theme.dart';

class LikesCard extends StatefulWidget {
  final UserPostModel post;
  final Function(String, UserPostModel, String) onUnlikePost;
  final Function(String, UserPostModel, String) onLikePost;
  final Function(String) onDeletePost;

  const LikesCard(
      {Key? key,
      required this.post,
      required this.onUnlikePost,
      required this.onLikePost,
      required this.onDeletePost})
      : super(key: key);

  @override
  LikesCardState createState() => LikesCardState();
}

class LikesCardState extends State<LikesCard>
    with SingleTickerProviderStateMixin {
  late bool isLiked;
  late int numberOfLikes;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.likedBy.contains(userProfile!.username);
    numberOfLikes = widget.post.numberOfLikes;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
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
    var screenWidth = MediaQuery.of(context).size.width;
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
                        color: OnlineTheme.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 24,
                        icon: const Icon(Icons.delete,
                            color: OnlineTheme.background),
                        onPressed: () async {
                          try {
                            widget.onDeletePost(widget.post.id);
                            print('Image deleted successfully');
                            PageNavigator.navigateTo(const DummyDisplay2());
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
                child: Icon(Icons.favorite,
                    size: 250, color: Colors.red.withOpacity(_animation.value)),
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
                  PageNavigator.navigateTo(
                      LikedByPageDisplay(post: widget.post,));
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
        ),
      ],
    );
  }
}
