import 'package:flutter/material.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';

import '../home/event_card.dart';
import '../../components/online_scaffold.dart';
import '../../theme/theme.dart';
import '/main.dart';

class EventsPage extends ScrollablePage {
  const EventsPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: OnlineHeader.height(context) + 40),
        Text(
          'Kommende Arrangementer',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          height: 111 * 12,
          child: ListView.builder(
            itemCount: 12,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) => EventCard(
              model: testModels[i % 6],
            ),
          ),
        ),
        SizedBox(height: Navbar.height(context)),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return OnlineScaffold(
  //     header: const ProfileButton(),
  //     content: SingleChildScrollView(
  //       // Wrap the Column with SingleChildScrollView
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           const SizedBox(height: 10),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => const MyEventsPage(),
  //                 ),
  //               );
  //             },
  //             style: TextButton.styleFrom(
  //               backgroundColor: OnlineTheme.gray14,
  //               padding: const EdgeInsets.symmetric(vertical: 40.0),
  //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  //             ),
  //             child: const Text(
  //               'Gå til mine kommende arrangementer',
  //               style: OnlineTheme.goToButton,
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           Container(
  //             margin: const EdgeInsets.symmetric(vertical: 10),
  //             height: 111 * 6,
  //             child: ListView.builder(
  //               itemCount: 6,
  //               padding: EdgeInsets.zero,
  //               physics: const NeverScrollableScrollPhysics(),
  //               itemBuilder: (c, i) => EventCard(
  //                 model: testModels[0],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
