import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/core/models/event_organizers.dart';

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
import 'cards/event_registration_card.dart';

class EventPage extends ScrollablePage {
  const EventPage({super.key, required this.model});
//
  final EventModel model;

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
      buttons: [
        if (loggedIn)
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
          child: model.images.isNotEmpty
              ? Image.network(
                  model.images.first.original,
                  fit: BoxFit.cover,
                )
              : SvgPicture.asset(
                  'assets/svg/online_hvit_o.svg', // Replace with your default image asset path
                  fit: BoxFit.cover,
                ),
        ),
        Padding(
          padding: horizontalPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                model.title,
                style: OnlineTheme.textStyle(size: 20, weight: 7),
              ),
              const SizedBox(height: 24),
              AttendanceCard(
                model: model,
              ),
              const SizedBox(height: 24),
              EventDescriptionCard(
                description: model.description,
                organizer: eventOrganizers[model.organizer] ?? '',
              ),
              const SizedBox(height: 24),
              RegistrationCard(
                model: model, // Pass the model here
              ),
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
  
  const RegistrationCard({super.key, required this.model});
final EventModel model;

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
          EventParticipants(
            model: model,
          ),
          const SizedBox(height: 16),
          const EventRegistrationCard(), // Add the countdown widget here
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
          text: 'Åpen',
        )
      ],
    ),
  );
}
