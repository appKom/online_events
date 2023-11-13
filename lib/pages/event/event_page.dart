import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/pages/event/widgets/EventCardCountdown.dart';
import 'package:online_events/pages/event/widgets/eventCardButtons.dart';
import 'package:online_events/pages/event/widgets/event_participants.dart';

import 'package:online_events/theme/theme.dart';

class EventPage extends ScrollablePage {
  const EventPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 24);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: OnlineHeader.height(context)),
        SizedBox(
          height: 267,
          child: Image.asset(
            'assets/images/heart.png',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: horizontalPadding,
          child: Text(
            'Flørtekurs på A4',
            style: OnlineTheme.eventHeader,
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: horizontalPadding,
          child: AttendanceCard(),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: horizontalPadding,
          child: DescriptionCard(),
        ),
        const SizedBox(
          height: 20,
        ),
        const Padding(padding: horizontalPadding, child: RegistrationCard()),
        const SizedBox(height: 24),
        SizedBox(
          height: Navbar.height(context) + 24,
        ),
      ],
    );
  }
}

/// Påmelding
class RegistrationCard extends StatelessWidget {
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 24);
  const RegistrationCard({Key? key});

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header(),
          const SizedBox(height: 16),
          const EventParticipants(),
          const SizedBox(height: 16),
          const EventCardCountdown(), // Add the countdown widget here
          const SizedBox(height: 20),
          const EventCardButtons(), // Removed Padding widget
        ],
      ),
    );
  }
}

/// Card header
Widget header() {
  return SizedBox(
    height: 32,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Påmelding',
          style: OnlineTheme.eventHeader
              .copyWith(height: 1, fontWeight: FontWeight.w600),
        ),
        Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color.fromARGB(99, 133, 26, 2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color.fromARGB(255, 195, 3, 3),
            ),
          ),
          child: const Text(
            'Stengt',
            style: TextStyle(
              color: Color.fromARGB(255, 195, 3, 3),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Oppmøte
class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key});

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
          content(),
        ],
      ),
    );
  }


  /// Card Content
  Widget content() {
    return Column(
      children: [
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
                  AnimatedButton(
                    //
                    child: Image.asset(
                      'assets/images/maze_map.png',
                      width: 18,
                      height: 17.368,
                    ),
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

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({super.key});

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
        'Beskrivelse',
        style: OnlineTheme.textStyle(
            size: 20, color: OnlineTheme.orange10, weight: 6),
      ),
    );
  }

  /// Card Content
  Widget content() {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 25);
    return Column(
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: horizontalPadding,
          child: Text(
            'Har du noen gang latt deg inspere av Appkoms sjuke sjekkereplikker. Ta turen til A4!...',
            style: OnlineTheme.textStyle(
                weight: 4, size: 15, color: OnlineTheme.white),
          ),
        ),
        Padding(
          padding: horizontalPadding,
          child: Text(
            'Les mer',
            style: OnlineTheme.textStyle(
                weight: 4, size: 15, color: OnlineTheme.yellow),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Av Appkom <3',
              style: OnlineTheme.textStyle(),
            )
          ],
        ),
        // Positioned(
        //     right: 5,
        //     bottom: 5,
        //     child: Text(
        //       'Av Appkom <3',
        //       style: OnlineTheme.textStyle(),
        //     ))
      ],
    );
  }
}
