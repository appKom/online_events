import 'package:flutter/material.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/pages/event/cards/event_card_buttons.dart';
import 'package:online_events/pages/event/cards/event_card_countdown.dart';
import 'package:online_events/pages/event/cards/event_participants.dart';
import 'package:online_events/pages/event/cards/event_registration_card.dart';
import 'package:online_events/pages/event/event_page.dart';
import '/main.dart';
import '/theme/theme.dart';



class RegistrationCard extends StatelessWidget {
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 24);

  const RegistrationCard(
      {super.key, required this.model, required this.attendeeInfoModel, required this.onUnregisterSuccess,});
  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;
  final VoidCallback onUnregisterSuccess;

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
          if (loggedIn ||
              attendeeInfoModel.isEligibleForSignup.statusCode == 6969)
            header(attendeeInfoModel.isEligibleForSignup.statusCode),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            const SizedBox(height: 16),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            EventParticipants(
              model: model,
              attendeeInfoModel: attendeeInfoModel,
            ),
          const SizedBox(height: 16),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            EventRegistrationCard(
              attendeeInfoModel: attendeeInfoModel,
            ),
          const SizedBox(height: 10),
          if ((loggedIn == true &&
                  attendeeInfoModel.isEligibleForSignup.status == false) ||
              (loggedIn == false &&
                  attendeeInfoModel.isEligibleForSignup.statusCode == 6969))
            Center(
              child: Text(
                attendeeInfoModel.isEligibleForSignup.message,
                style: OnlineTheme.textStyle(),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          EventCardButtons(
            model: model,
            attendeeInfoModel: attendeeInfoModel, onUnregisterSuccess: onUnregisterSuccess,
          ),
          if (loggedIn &&
              attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            const SizedBox(
              height: 16,
            ),
          if (attendeeInfoModel.isEligibleForSignup.statusCode == 501)
            EventCardCountdown(eventTime: eventDateTime),
          if (attendeeInfoModel.isEligibleForSignup.statusCode == 501)
            Center(
                child: Text(
              'Til til arrangementet starter',
              style: OnlineTheme.textStyle(weight: 5),
            )),
          if (attendeeInfoModel.id == -1 &&
              eventDateTime.isAfter(DateTime.now()))
            EventCardCountdown(eventTime: eventDateTime),
          if (attendeeInfoModel.id == -1 &&
              eventDateTime.isAfter(DateTime.now()))
            const SizedBox(
              height: 10,
            ),
          if (attendeeInfoModel.id == -1 &&
              eventDateTime.isAfter(DateTime.now()))
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