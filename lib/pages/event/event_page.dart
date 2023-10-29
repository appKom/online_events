import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/theme.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 24);

    return Material(
      color: OnlineTheme.background,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: OnlineTheme.white,
              height: 267,
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: horizontalPadding,
              child: Text(
                'Surfetur til Portugal 2023',
                style: OnlineTheme.eventHeader,
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: horizontalPadding,
              child: EventPageAttendanceCard(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Oppmøte.
class EventPageAttendanceCard extends StatelessWidget {
  const EventPageAttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: OnlineTheme.background.lighten(20),
        border: Border.all(color: OnlineTheme.gray10.darken(80), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(),
          const SizedBox(height: 16),
          content(),
        ],
      ),
    );
  }

  /// Card header
  Widget header() {
    return SizedBox(
      height: 32,
      child: Text(
        'Oppmøte',
        style: OnlineTheme.eventHeader.copyWith(height: 1, fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Card Content
  Widget content() {
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 21,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/date_time.svg', height: 21),
              const SizedBox(width: 16),
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(
                  'tirsdag 31. okt., 16:15 - 20:00',
                  style: TextStyle(
                    color: OnlineTheme.white,
                    fontSize: 14,
                    fontFamily: OnlineTheme.font,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 21,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/location.svg', height: 21),
              const SizedBox(width: 16),
              const Text(
                'R1, Realfagbygget',
                style: TextStyle(
                  color: OnlineTheme.white,
                  fontSize: 14,
                  fontFamily: OnlineTheme.font,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                height: 21,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: OnlineTheme.blue1,
                ),
                child: Row(children: [
                  Image.asset(
                    'assets/images/maze_map.png',
                    width: 18,
                    height: 17.368,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'MazeMap',
                    style: TextStyle(
                      color: OnlineTheme.white,
                      fontSize: 14,
                      fontFamily: OnlineTheme.font,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// class EventPage extends StatelessWidget {
//   const EventPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: OnlineTheme.background,
//       child: Stack(
//         children: [
//           ListView(
//             children: [
//               Container(
//                 color: OnlineTheme.white,
//                 height: 267,
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(top: 24, left: 40, right: 40),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text(
//                       'Surfetur til Portugal 2023',
//                       style: OnlineTheme.eventHeader,
//                     ),
//                     Text(
//                       'Av X-Sport',
//                       style: OnlineTheme.eventListSubHeader,
//                     ),
//                     EventDateCard(),
//                     EventParticipants(),
//                     EventLocation(),
//                     Text(
//                       'Description',
//                       style: OnlineTheme.eventCardDate,
//                     ),
//                     Text(
//                       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ',
//                       style: OnlineTheme.eventCardDescription,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16), // Add some space
//             ],
//           ),
//           const Align(
//             alignment: Alignment.bottomCenter,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 EventCardButtons(),
//                 SizedBox(height: 8), // Add space between buttons and text
//                 Text(
//                   'Påmeldnings: 12:00 25. Oktober  ',
//                   style: OnlineTheme.eventCardBottomText,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }