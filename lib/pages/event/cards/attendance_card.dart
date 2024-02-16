import 'package:flutter/material.dart';

import '/components/separator.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import 'event_card.dart';
import 'event_card_countdown.dart';
import 'event_date_formater.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key, required this.event, required this.attendeeInfo});

  final EventModel event;
  final AttendeeInfoModel attendeeInfo;

  bool showCountdownToRegistrationStart() {
    // Registration has startet - no need for a countdown
    if (DateTime.now().isAfter(attendeeInfo.registrationStart)) return false;

    return true;
  }

  Widget countdownToRegistrationStart() {
    return Column(
      children: [
        const Separator(margin: 24),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Påmelding åpner om',
            style: OnlineTheme.textStyle(weight: 5),
          ),
        ),
        EventCardCountdown(eventTime: attendeeInfo.registrationStart),
      ],
    );
  }

  bool showCountdownToEventStart() {
    final eventDateTime = DateTime.parse(event.startDate);

    // Registration is still open - don't show countdown yet
    if (attendeeInfo.registrationEnd.isAfter((DateTime.now()))) return false;

    // Event has already started
    if (DateTime.now().isAfter(eventDateTime)) return false;

    return true;
  }

  Widget countdownToEventStart() {
    final eventDateTime = DateTime.parse(event.startDate);

    return Column(
      children: [
        const Separator(margin: 24),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            'Arrangementet starter om',
            style: OnlineTheme.textStyle(weight: 5),
          ),
        ),
        EventCardCountdown(eventTime: eventDateTime),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnlineCard(
      child: Column(
        children: [
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ThemedIcon(icon: IconType.dateTime, size: 20),
                const SizedBox(width: 8),
                Text(
                  EventDateFormatter.formatEventDates(event.startDate, event.endDate),
                  style: OnlineTheme.textStyle(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ThemedIcon(icon: IconType.location, size: 20),
                const SizedBox(width: 8),
                Text(
                  event.location,
                  style: OnlineTheme.textStyle(),
                ),
              ],
            ),
          ),
          if (showCountdownToRegistrationStart()) countdownToRegistrationStart(),
          if (showCountdownToEventStart()) countdownToEventStart(),
        ],
      ),
    );
  }
}
