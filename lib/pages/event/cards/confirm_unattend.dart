// import 'package:flutter/material.dart';

// import '/components/animated_button.dart';
// import '/dark_overlay.dart';
// import '/pages/event/cards/event_card_buttons.dart';
// import '/theme/theme.dart';

// class ConfirmUnattend extends DarkOverlay {
//   final VoidCallback onConfirm;

//   ConfirmUnattend({required this.onConfirm});

//   @override
//   Widget content(BuildContext context, Animation<double> animation) {
//     return LayoutBuilder(builder: (context, constraints) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Bekreft Avmelding',
//             style: OnlineTheme.textStyle(size: 25, weight: 7),
//           ),
//           const SizedBox(height: 40),
//           Row(
//             children: [
//               const Spacer(),
//               SizedBox(
//                 height: 200,
//                 width: 200,
//                 child: AnimatedButton(
//                   onTap: () {
//                     setState(() {
//                       isRegistered = false;
//                       navigator?.pop(context);
//                     });
//                   },
//                   childBuilder: (context, hover, pointerDown) {
//                     return Container(
//                       alignment: Alignment.center,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         gradient: OnlineTheme.greenGradient,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Text('Bekreft', style: OnlineTheme.textStyle()),
//                     );
//                   },
//                 ),
//               ),
//               const Spacer(),
//               SizedBox(
//                 height: 200,
//                 width: 200,
//                 child: AnimatedButton(
//                   onTap: () {
//                     setState(() {
//                       navigator?.pop(context);
//                     });
//                   },
//                   childBuilder: (context, hover, pointerDown) {
//                     return Container(
//                       alignment: Alignment.center,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         gradient: OnlineTheme.redGradient,
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: Text('Ikke bekreft', style: OnlineTheme.textStyle()),
//                     );
//                   },
//                 ),
//               ),
//               const Spacer()
//             ],
//           ),
//         ],
//       );
//     });
//   }
// }
