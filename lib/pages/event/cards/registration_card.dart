import 'package:flutter/material.dart';

import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';
import '/main.dart';
import '/pages/event/cards/event_card.dart';
import '/pages/event/cards/event_card_buttons.dart';
import '/pages/event/cards/event_card_countdown.dart';
import '/pages/event/cards/event_participants.dart';
import '/theme/theme.dart';
import 'card_badge.dart';
import 'registration_info.dart';

class RegistrationCard extends StatelessWidget {
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 24);

  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;
  final VoidCallback onUnregisterSuccess;

  const RegistrationCard({
    super.key,
    required this.model,
    required this.attendeeInfoModel,
    required this.onUnregisterSuccess,
  });

  Widget header(int statusCode) {
    String badgeText;
    // LinearGradient gradient;

    Color color;

    switch (statusCode) {
      case 502:
        badgeText = 'Stengt';
        // gradient = OnlineTheme.redGradient;
        color = OnlineTheme.red;
        break;
      case 404:
        badgeText = 'Påmeldt';
        // gradient = OnlineTheme.greenGradient;
        color = OnlineTheme.green;
        break;
      case 200 || 201 || 210 || 211 || 212 || 213:
        badgeText = 'Åpen';
        color = OnlineTheme.green;
        // gradient = OnlineTheme.greenGradient;
        break;
      case 420 || 421 || 422 || 423 || 401 || 402:
        badgeText = 'Utsatt';
        // gradient = OnlineTheme.blueGradient;
        color = OnlineTheme.yellow;
        break;
      case 411 || 410 || 412 || 413 || 400 || 400 || 403 || 405:
        badgeText = 'Umulig';
        // gradient = OnlineTheme.redGradient;
        color = OnlineTheme.red;
        break;
      default:
        badgeText = 'Ikke Åpen';
        // gradient = OnlineTheme.redGradient;
        color = OnlineTheme.red;
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
            style: OnlineTheme.header(),
          ),
          CardBadge(
            text: badgeText,
            fill: color.withOpacity(0.4),
            border: color,
            // border: gradient.colors.last.lighten(100),
            // gradient: gradient,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventDateTime = DateTime.parse(model.startDate);
    return OnlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // if (loggedIn || attendeeInfoModel.isEligibleForSignup.statusCode == 6969)
          header(attendeeInfoModel.isEligibleForSignup.statusCode),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 6969) const SizedBox(height: 16),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            EventParticipants(
              model: model,
              attendeeInfoModel: attendeeInfoModel,
            ),
          const SizedBox(height: 16),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            RegistrationInfo(
              attendeeInfoModel: attendeeInfoModel,
            ),
          const SizedBox(height: 10),
          if ((loggedIn == true && attendeeInfoModel.isEligibleForSignup.status == false) ||
              (loggedIn == false && attendeeInfoModel.isEligibleForSignup.statusCode == 6969))
            if (attendeeInfoModel.isOnWaitlist == false)
              Center(
                child: Text(
                  attendeeInfoModel.isEligibleForSignup.message,
                  style: OnlineTheme.textStyle(),
                ),
              ),
          if (attendeeInfoModel.isOnWaitlist == true)
            Center(
              child: Text(
                'Du er nummer ${attendeeInfoModel.whatPlaceIsUserOnWaitList} på venteliste',
                style: OnlineTheme.textStyle(),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          EventCardButtons(
            model: model,
            attendeeInfoModel: attendeeInfoModel,
            onUnregisterSuccess: onUnregisterSuccess,
          ),
          if (loggedIn && attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            const SizedBox(
              height: 16,
            ),
          if (attendeeInfoModel.isEligibleForSignup.statusCode == 501) EventCardCountdown(eventTime: eventDateTime),
          if (attendeeInfoModel.isEligibleForSignup.statusCode == 501)
            Column(
              children: [
                const SizedBox(
                  height: 6,
                ),
                Center(
                  child: Text(
                    'Til til arrangementet starter',
                    style: OnlineTheme.textStyle(weight: 5),
                  ),
                ),
              ],
            ),
          if (attendeeInfoModel.id == -1 && eventDateTime.isAfter(DateTime.now()))
            EventCardCountdown(eventTime: eventDateTime),
          if (attendeeInfoModel.id == -1 && eventDateTime.isAfter(DateTime.now()))
            const SizedBox(
              height: 10,
            ),
          if (attendeeInfoModel.id == -1 && eventDateTime.isAfter(DateTime.now()))
            Center(
                child: Text(
              'Til til arrangementet starter',
              style: OnlineTheme.textStyle(weight: 5),
            )),
        ],
      ),
    );
  }
}
