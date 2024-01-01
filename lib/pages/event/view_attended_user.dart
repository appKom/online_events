// import 'package:appwrite/appwrite.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:online_events/pages/pixel/models/pixel_user_class.dart';
// import 'package:online_events/theme/theme.dart';

// import '../../components/animated_button.dart';
// import '../../components/online_header.dart';
// import '../../components/online_scaffold.dart';
// import '../../components/separator.dart';
// import '../home/profile_button.dart';

// class ViewAttendedUser extends StatefulWidget {
//   const ViewAttendedUser({super.key, required this.userName});

//   final String userName;

//   @override
//   ViewPixelUserState createState() => ViewPixelUserState();
// }

// class ViewPixelUserState extends State<ViewAttendedUser> {
//   late Databases database;
//   PixelUserClass? userData;

//   @override
//   void initState() {
//     super.initState();
//     final client = Client()
//         .setEndpoint('https://cloud.appwrite.io/v1')
//         .setProject(dotenv.env['PROJECT_ID']);
//     database = Databases(client);

//     List<String> names = widget.userName.split(' ');
//       String firstName = names[0];
//       String lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

//       print(firstName);
//       print(lastName);
    

//     fetchPixelUserInfo().then((userData) {
//       if (userData != null) {
//         setState(() {
//           this.userData = userData;
//         });
//       }
//     });
//   }

//   Future<PixelUserClass?> fetchPixelUserInfo() async {
//     try {
//       // Split the userName into first and last names
//       List<String> names = widget.userName.split(' ');
//       String firstName = names[0];
//       String lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

//       print(firstName);
//       print(lastName);
//       // Use listDocuments with queries to find the user by firstName and lastName
//       final response = await database.listDocuments(
//         collectionId: dotenv.env['USER_COLLECTION_ID']!,
//         databaseId: dotenv.env['USER_DATABASE_ID']!,
//         queries: [
//           Query.equal('first_name', firstName),
//           Query.equal('last_name', lastName),
//         ],
//       );

//       if (response.documents.isNotEmpty) {
//         // Assuming the first matching document is the correct one
//         return PixelUserClass.fromJson(response.documents.first.data);
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: OnlineHeader.height(context) + 50),
//         Text(
//           '${userData?.firstName} ${userData?.lastName}',
//           style: OnlineTheme.textStyle(size: 32),
//         ),
//         const SizedBox(
//           height: 16,
//         ),
//         AnimatedButton(onTap: () {
//           //Eyo
//         }, childBuilder: (context, hover, pointerDown) {
//           return ClipOval(
//             child: SizedBox(
//               width: 300,
//               height: 300,
//               child: Image.network(
//                 'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['USER_BUCKET_ID']}/files/${widget.userName}/view?project=${dotenv.env['PROJECT_ID']}&mode=public',
//                 fit: BoxFit.cover,
//                 height: 300,
//                 loadingBuilder: (BuildContext context, Widget child,
//                     ImageChunkEvent? loadingProgress) {
//                   if (loadingProgress == null) {
//                     return child;
//                   }
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                               loadingProgress.expectedTotalBytes!
//                           : null,
//                     ),
//                   );
//                 },
//                 errorBuilder: (BuildContext context, Object exception,
//                     StackTrace? stackTrace) {
//                   return Image.asset(
//                     'assets/images/default_profile_picture.png',
//                     fit: BoxFit.cover,
//                     height: 300,
//                   );
//                 },
//               ),
//             ),
//           );
//         }),
//         const SizedBox(
//           height: 10,
//         ),
//         Text(
//           '${userData?.year}. Klasse',
//           style: OnlineTheme.textStyle(weight: 5, size: 18),
//         ),
//         const Separator(
//           margin: 10,
//         ),
//         Text(
//           userData?.biography ?? '',
//           style: OnlineTheme.textStyle(),
//         ),
//       ],
//     );
//   }
// }

// class ViewAttendedUserDisplay extends StaticPage {
//   const ViewAttendedUserDisplay({super.key, required this.userName});

//   final String userName;

//   @override
//   Widget? header(BuildContext context) {
//     return OnlineHeader(
//       buttons: const [
//         ProfileButton(),
//       ],
//     );
//   }

//   @override
//   Widget content(BuildContext context) {
//     return ViewAttendedUser(
//       userName: userName,
//     );
//   }
// }
