import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:online/main.dart';
import 'package:timezone/timezone.dart' as tz;

import '/components/animated_button.dart';
import '/components/separator.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import 'event_card.dart';
import 'event_card_countdown.dart';
import 'event_date_formater.dart';

class NotificationModel {
  static const channelId = "online_events";
  static const channelName = "Online Events";
  static const channelDescription = "Reminders about event registrations and event starts.";

  static const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    channelName,
    channelDescription: channelDescription,
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
  );
  static const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
  static const platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  final DateTime time;
  final String header;
  final String body;

  late final int id;

  NotificationModel({required this.time, required this.header, required this.body}) {
    id = time.hashCode;
  }

  tz.TZDateTime zonedTime() {
    return tz.TZDateTime.from(time, tz.local);
  }
}

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key, required this.event, required this.attendeeInfo});

  final EventModel event;
  final AttendeeInfoModel attendeeInfo;

  bool showCountdownToRegistrationStart() {
    // Registration has started - no need for a countdown
    if (DateTime.now().isAfter(attendeeInfo.registrationStart)) return false;

    return true;
  }

  Widget countdownToRegistrationStart() {
    return Column(
      children: [
        const Separator(margin: 24),
        Text(
          'Påmelding åpner om',
          style: OnlineTheme.textStyle(weight: 5),
        ),
        const SizedBox(height: 10),
        EventCardCountdown(eventTime: attendeeInfo.registrationStart),
        const SizedBox(height: 24),
        notifyEventRegistration(),
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

  void showNotification() {}

  Widget notifyEventRegistration() {
    return AnimatedButton(
      onTap: () async {
        final scheduleNotificationDateTime = attendeeInfo.registrationStart.subtract(const Duration(minutes: 15));

        final notification = NotificationModel(
          time: scheduleNotificationDateTime,
          header: 'Påmelding Snart!',
          body: 'Påmelding til ${event.title} starter om 15 minutter.',
        );

        flutterLocalNotificationsPlugin.show(
          0,
          'Varsling På',
          'Du vil bli varslet 15 min før påmelding starter.',
          const NotificationDetails(
            iOS: DarwinNotificationDetails(),
          ),
        );

        await flutterLocalNotificationsPlugin.zonedSchedule(
          notification.id,
          notification.header,
          notification.body,
          notification.zonedTime(),
          NotificationModel.platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        );
      },
      childBuilder: (context, hover, pointerDown) {
        return Container(
          height: OnlineTheme.buttonHeight,
          decoration: BoxDecoration(
            color: OnlineTheme.yellow.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.0),
            border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.yellow, width: 2)),
          ),
          alignment: Alignment.center,
          child: Text(
            'Varsle Meg',
            style: OnlineTheme.textStyle(
              weight: 5,
              color: OnlineTheme.yellow,
            ),
          ),
        );
      },
    );
  }

  Widget notifyAttendance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        AnimatedButton(
          onTap: () async {
            final DateTime parsedStartDate = DateTime.parse(event.startDate);

            final scheduleNotificationDateTime = parsedStartDate.subtract(const Duration(minutes: 60));

            final notification = NotificationModel(
              time: scheduleNotificationDateTime,
              header: 'Arrangement starter snart!',
              body: '${event.title} starter om 1 time.',
            );

            flutterLocalNotificationsPlugin.show(
              0,
              'Varsling På',
              'Du vil bli varslet 1 time før arrangementet starter',
              const NotificationDetails(
                iOS: DarwinNotificationDetails(),
              ),
            );

            await flutterLocalNotificationsPlugin.zonedSchedule(
              notification.id,
              notification.header,
              notification.body,
              notification.zonedTime(),
              NotificationModel.platformChannelSpecifics,
              androidScheduleMode: AndroidScheduleMode.alarmClock,
              uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
              // matchDateTimeComponents: DateTimeComponents.time,
            );
          },
          childBuilder: (context, hover, pointerDown) {
            return Container(
              height: OnlineTheme.buttonHeight,
              decoration: BoxDecoration(
                color: OnlineTheme.yellow.withOpacity(0.4),
                borderRadius: BorderRadius.circular(5.0),
                border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.yellow, width: 2)),
              ),
              alignment: Alignment.center,
              child: Text(
                'Varsle Meg',
                style: OnlineTheme.textStyle(
                  weight: 5,
                  color: OnlineTheme.yellow,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget header() {
    return SizedBox(
      height: 32,
      child: Text(
        'Tid & Sted',
        style: OnlineTheme.header(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header(),
          const SizedBox(height: 16),
          Row(
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
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ThemedIcon(icon: IconType.location, size: 20),
                const SizedBox(width: 8),
                Text(
                  event.location,
                  style: OnlineTheme.textStyle(),
                  softWrap: true,
                ),
              ],
            ),
          ),
          if (showCountdownToRegistrationStart()) countdownToRegistrationStart(),
          if (showCountdownToEventStart()) countdownToEventStart(),
          if (attendeeInfo.isAttendee) notifyAttendance(),
        ],
      ),
    );
  }
}
