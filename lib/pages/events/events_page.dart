import 'package:flutter/material.dart';

import '/pages/home/profile_button.dart';
import 'my_events_page.dart';
import '../home/event_card.dart';
import '../../components/online_scaffold.dart';
import '../../theme/theme.dart';
import '/main.dart';

class EventsPage extends ScrollablePage {
  const EventsPage({super.key});

  @override
  Widget content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyEventsPage(),
              ),
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: OnlineTheme.gray14,
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
          child: const Text(
            'Gå til mine kommende arrangementer',
            style: OnlineTheme.goToButton,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 111 * 6,
          child: ListView.builder(
            itemCount: 6,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) => EventCard(
              model: testModels[0],
            ),
          ),
        ),
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
