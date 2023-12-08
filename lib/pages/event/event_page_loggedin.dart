import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/core/models/event_organizers.dart';
import 'package:online_events/pages/event/cards/event_attendees.dart';
import 'package:online_events/pages/event/cards/event_card_countdown.dart';
import 'package:online_events/pages/event/cards/event_participants_loggedin.dart';
import 'package:online_events/pages/event/cards/event_registration_card_loggedin.dart';
import 'package:online_events/pages/profile/profile_page.dart';

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

class EventPageLoggedIn extends ScrollablePage {
  const EventPageLoggedIn(
      {super.key, required this.model, required this.attendeeInfoModel});
//
  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;

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
          height: 230,
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
                model: model,
                attendeeInfoModel: attendeeInfoModel,
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

  const RegistrationCard(
      {super.key, required this.model, required this.attendeeInfoModel});
  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;

  @override
  Widget build(BuildContext context) {
    final eventDateTime = DateTime.parse(model.startDate);
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
          header(attendeeInfoModel.isEligibleForSignup.statusCode),
          const SizedBox(height: 16),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 502 &&
              attendeeInfoModel.isEligibleForSignup.statusCode != 411 &&
              attendeeInfoModel.isEligibleForSignup.statusCode != 6969 &&
              attendeeInfoModel.isEligibleForSignup.statusCode != 404)
            EventParticipantsLoggedIn(
              model: model,
              attendeeInfoModel: attendeeInfoModel,
            ),
          const SizedBox(height: 16),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 502 &&
              attendeeInfoModel.isEligibleForSignup.statusCode != 411 &&
              attendeeInfoModel.isEligibleForSignup.statusCode != 404 &&
              attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            EventRegistrationCardLoggedIn(attendeeInfoModel: attendeeInfoModel),
          const SizedBox(height: 10),
          attendeeInfoModel.isEligibleForSignup.status
              ? const EventCardButtons()
              : Text(
                  attendeeInfoModel.isEligibleForSignup.message,
                  style: OnlineTheme.textStyle(),
                ),
            const SizedBox(height: 10,),
            if (attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            const EventAttendees(),

          const SizedBox(
            height: 10,
          ),
          attendeeInfoModel.id == -1
              ? EventCardCountdown(
                  eventTime:
                      eventDateTime) // Include countdown if attendeeInfoModel.id is -1
              : const SizedBox.shrink(), // Otherwise, include an empty widget
        ],
      ),
    );
  }
}

Widget header(int statusCode) {
  String badgeText;
  LinearGradient gradient;

  switch (statusCode) {
    case 502:
      badgeText = 'Closed';
      gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.redAccent, Colors.red], // Red gradient
      );
      break;

    case 404:
      badgeText = 'Closed';
      gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.redAccent, Colors.red], // Red gradient
      );
      break;
    case 6969:
      badgeText = 'Ikke åpen';
      gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.purpleAccent, Colors.purple], // Purple gradient
      );
      break;
    case 411:
      badgeText = 'Umulig';
      gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.blueAccent, Colors.blue], // Blue gradient
      );
      break;
    default:
      badgeText = 'Åpen';
      gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          OnlineTheme.green5, // Start color
          OnlineTheme.green1, // End color
        ],
      );
  }

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
          border: gradient.colors.last.lighten(100),
          gradient: gradient,
          text: badgeText,
        ),
      ],
    ),
  );
}
