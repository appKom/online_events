import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/pages/event/cards/event_card_pre_buttons.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/theme/theme.dart';
import 'cards/event_card_countdown.dart';
import 'cards/event_participants.dart';

class EventPagePre extends ScrollablePage {
  const EventPagePre({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
        // buttons: [
        // SizedBox.square(
        //   dimension: 40,
        //   child: Center(
        //     child: AnimatedButton(
        //       onPressed: () {
        //         print('📸');
        //       },
        //       child: const ThemedIcon(
        //         icon: IconType.camScan,
        //         size: 24,
        //         color: OnlineTheme.white,
        //       ),
        //     ),
        //   ),
        // ),
        // if (loggedIn)
        //   SizedBox.square(
        //     dimension: 40,
        //     child: Center(
        //       child: AnimatedButton(
        //         onPressed: () {
        //           AppNavigator.navigateToRoute(
        //             QRCode(name: 'Fredrik Hansteen'),
        //             additive: true,
        //           );
        //         },
        //         child: const ThemedIcon(
        //           icon: IconType.qr,
        //           size: 24,
        //           color: OnlineTheme.white,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
        );
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
            'assets/images/SopraSteria.jpg',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: horizontalPadding,
          child: Text(
            'Bedriftspresentasjon med Sopra Steria',
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
  const RegistrationCard({super.key});

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
          const EventCardPreButtons(),
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
          style: OnlineTheme.eventHeader.copyWith(height: 1, fontWeight: FontWeight.w600),
        ),
        Container(
          height: 24,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: OnlineTheme.purple1,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: OnlineTheme.purple1.lighten(100),
            ),
          ),
          child: const Center(
            child: Text(
              'Ikke Åpen',
              style: TextStyle(
                color: OnlineTheme.white,
              ),
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

class DescriptionCard extends StatefulWidget {
  const DescriptionCard({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DescriptionCardState createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<DescriptionCard> {
  bool _isExpanded = false;

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
        style: OnlineTheme.textStyle(size: 20, color: OnlineTheme.orange10, weight: 6),
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
            _isExpanded
                // Full beskrivelse
                ? 'Bli med på en gøyal kveld med Sopra Steria, Norges ledende konsulentselskap innen digitalisering! Vi har gleden av å invitere deg til en hyggelig kveld på Sopra Steria sitt kontor! Bedriftspresentasjonen vil bestå av et lavterskel krasjkurs på 45 minutter i Sanity CMS og Next.js, etterfulgt av pizza, drikke og spill i kantinen deres. Vi gleder oss til å se deg der! Inngangen er på sjøsiden. English: The event will be held in Norwegian.'
                : 'Bli med på en gøyal kveld med Sopra Steria, Norges ledende konsulentselskap innen digit...',
            style: OnlineTheme.textStyle(weight: 4, size: 15, color: OnlineTheme.white),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'Vis mindre' : 'Les mer',
            style: OnlineTheme.textStyle(weight: 4, size: 15, color: OnlineTheme.yellow),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Av Bedkom',
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
