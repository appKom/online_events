import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/main.dart';
import '/pages/event/qr_code.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import 'cards/card_badge.dart';
import 'cards/attendance_card.dart';
import 'cards/event_card_buttons.dart';
import 'cards/event_description_card.dart';
import 'cards/event_participants.dart';
import 'cards/event_regestration_card.dart';

class EventPage extends ScrollablePage {
  const EventPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
      buttons: [
        SizedBox.square(
          dimension: 40,
          child: Center(
            child: AnimatedButton(
              onTap: () {
                print('📸');
              },
              childBuilder: (context, hover, pointerDown) {
                return const ThemedIcon(
                  icon: IconType.camScan,
                  size: 24,
                  color: OnlineTheme.white,
                );
              },
            ),
          ),
        ),
        if (loggedIn)
          SizedBox.square(
            dimension: 40,
            child: Center(
              child: AnimatedButton(
                onTap: () {
                  AppNavigator.navigateToRoute(
                    QRCode(name: 'Fredrik Hansteen'),
                    additive: true,
                  );
                },
                childBuilder: (context, hover, pointerDown) {
                  return const ThemedIcon(
                    icon: IconType.qr,
                    size: 24,
                    color: OnlineTheme.white,
                  );
                },
              ),
            ),
          ),
      ],
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
            'assets/images/heart.png',
            fit: BoxFit.cover,
          ),
        ),
        const Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24),
              Text(
                'Flørtekurs med Appkom',
                style: OnlineTheme.eventHeader,
              ),
              SizedBox(height: 24),
              AttendanceCard(),
              SizedBox(height: 24),
              EventDescriptionCard(
                description:
                    'Har du noen gang latt deg inspere av Appkoms sjuke sjekkereplikker? Ta turen til A4, og la deg inspirere.\n\nThis course will be held in Norwegian.',
              ),
              SizedBox(height: 24),
              RegistrationCard(),
              SizedBox(height: 24),
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
          const EventParticipants(),
          const SizedBox(height: 16),
          const EventRegestrationCard(), // Add the countdown widget here
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
        CardBadge(
          border: OnlineTheme.green5.lighten(100),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              OnlineTheme.green5, // Start color
              OnlineTheme.green1, // End color
            ],
          ),
          text: 'Ikke Åpen',
        )
      ],
    ),
  );
}
