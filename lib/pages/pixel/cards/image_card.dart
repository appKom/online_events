// import 'package:flutter/material.dart';
// import 'package:online_events/pages/pixel/models/user_post.dart';
// import '../../../components/animated_button.dart';
// import '../../../services/app_navigator.dart';
// import '../../profile/profile_page.dart';
// import '../pixel.dart';
// import '/theme/theme.dart';

// class ImageCard extends StatelessWidget {
//   const ImageCard(
//       {super.key,
//       required this.post,
//       required this.onLikePost,
//       required this.onDeletePost});

//   final UserPostModel post;
//   final Function(String, UserPostModel, String) onLikePost;
//   final Function(String) onDeletePost;

//   @override
//   Widget build(BuildContext context) {
//     var screenWidth = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onDoubleTap: () async {
//         if (!post.likedBy.contains(userProfile!.username.toString())) {
//           await onLikePost(post.id, post, userProfile!.username.toString());
//         }
//       },
//       child: Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           Image.network(
//             post.imageLink,
//             width: screenWidth,
//             fit: BoxFit.cover,
//           ),
//           if (post.username == userProfile!.username)
//             AnimatedButton(
//               childBuilder: (context, hover, pointerDown) {
//                 return Container(
//                   height: 35,
//                   width: 35,
//                   decoration: BoxDecoration(
//                     color: OnlineTheme.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 1,
//                         blurRadius: 1,
//                         offset: const Offset(0, 1),
//                       ),
//                     ],
//                   ),
//                   child: IconButton(
//                     padding: EdgeInsets.zero,
//                     iconSize: 24,
//                     icon:
//                         const Icon(Icons.delete, color: OnlineTheme.background),
//                     onPressed: () async {
//                       try {
//                         onDeletePost(post.id);
//                         print('Image deleted successfully');
//                         PageNavigator.navigateTo(const DummyDisplay2());
//                       } catch (e) {
//                         print("Error deleting image: $e");
//                       }
//                     },
//                   ),
//                 );
//               },
//             ),
//         ],
//       ),
//     );
//   }
// }
