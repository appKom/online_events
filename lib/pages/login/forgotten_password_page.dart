// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../home/home_page.dart';
// import '../home/profile_button.dart';
// import '/pages/login/email_sent_page.dart';
// import 'package:online_events/theme/theme.dart';

// class ForgottenPasswordPage extends StatelessWidget {
//   const ForgottenPasswordPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

//     return Material(
//       color: OnlineTheme.background,
//       child: Padding(
//         padding: padding,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 17),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     // Navigate to another page when the SVG image is tapped
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const HomePage()), // Replace with your page class
//                     );
//                   },
//                   child: SvgPicture.asset(
//                     'assets/header.svg',
//                     height: 36,
//                     fit: BoxFit.fitHeight,
//                   ),
//                 ),
//                 // const ProfileButton()
//               ],
//             ),
//             const SizedBox(height: 60),
//             Container(
//               width: 300,
//               height: 330,
//               padding: const EdgeInsets.only(bottom: 20),
//               margin: const EdgeInsets.only(right: 20),
//               child: Stack(
//                 children: [
//                   const Positioned(
//                       left: 0,
//                       right: 0,
//                       top: 0,
//                       height: 111,
//                       child: Text(
//                         'So you have forgotten your password...',
//                         style: OnlineTheme.loginPageHeader,
//                       )),
//                   const Positioned(
//                       left: 15,
//                       top: 60,
//                       child: Text(
//                         'Email:',
//                         style: OnlineTheme.loginPageEmail,
//                       )),
//                   const Positioned(
//                       left: 15,
//                       right: 15,
//                       top: 95,
//                       child: TextField(
//                         obscureText: false,
//                         style: OnlineTheme.loginPageEmail,
//                         decoration: InputDecoration(
//                             filled: true,
//                             fillColor: OnlineTheme.gray14,
//                             hintText: 'Enter your Email',
//                             hintStyle: OnlineTheme.logInnPageInput,
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(color: OnlineTheme.gray15),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(color: OnlineTheme.gray15),
//                             )),
//                       )),
//                   Positioned(
//                     left: 15,
//                     right: 0,
//                     top: 170,
//                     height: 65,
//                     child: GestureDetector(
//                       onTap: () {
//                         // Navigate to another page when the red box is tapped
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   const EmailSentPage()), // Replace with the page you want to navigate to
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: OnlineTheme.green3,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: const Center(
//                           child: Text(
//                             'Send Inn',
//                             style: OnlineTheme.logInnPageButton,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
