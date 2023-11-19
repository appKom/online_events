import 'package:flutter/material.dart';

import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/theme/theme.dart';
import 'cards/card_badge.dart';
import 'cards/event_card_countdown.dart';
import 'cards/event_card_pre_buttons.dart';
import 'cards/event_description_card.dart';

class EventPagePre extends ScrollablePage {
  const EventPagePre({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 24);

    return Column(
      children: [
        SizedBox(height: OnlineHeader.height(context)),
        SizedBox(
          height: 267,
          child: Image.asset(
            'assets/images/SopraSteria.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: horizontalPadding,
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                'Bedriftspresentasjon med Sopra Steria',
                style: OnlineTheme.textStyle(size: 20, weight: 7),
              ),
              const SizedBox(height: 24),
              // AttendanceCard(model: ,), // TODO
              const SizedBox(height: 24),
              const EventDescriptionCard(
                description:
                    'Bli med på en gøyal kveld med Sopra Steria, Norges ledende konsulentselskap innen digitalisering!\n\nVi har gleden av å invitere deg til en hyggelig kveld på Sopra Steria sitt kontor! Bedriftspresentasjonen vil bestå av et lavterskel krasjkurs på 45 minutter i Sanity CMS og Next.js, etterfulgt av pizza, drikke og spill i kantinen deres. Vi gleder oss til å se deg der! Inngangen er på sjøsiden.\n\nEnglish: The event will be held in Norwegian.',
                organizer: 'Appkom',
              ),
              const SizedBox(height: 24),
              const RegistrationCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
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
          const SizedBox(height: 16),
          EventCardCountdown(
            eventTime: DateTime(2023, 11, 19, 12, 0),
          ), // Add the countdown widget here
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
          style: OnlineTheme.textStyle(height: 1, weight: 7, size: 20),
        ),
        CardBadge(
          border: OnlineTheme.purple1.lighten(100),
          gradient: OnlineTheme.purpleGradient,
          text: 'Ikke Åpen',
        )
      ],
    ),
  );
}
