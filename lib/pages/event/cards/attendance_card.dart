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

  NotificationModel({required this.time, required this.header, required this.body, required this.id});

  tz.TZDateTime zonedTime() {
    return tz.TZDateTime.from(time, tz.local);
  }
}

class AttendanceCard extends StatelessWidget {
  AttendanceCard({super.key, required this.event, required this.attendeeInfo});

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

  final ValueNotifier<bool> willNotifyBeforeRegistration = ValueNotifier(false);

  Widget notifyEventRegistration() {
    Future registerNotification() async {
      willNotifyBeforeRegistration.value = true;

      final scheduleNotificationDateTime = attendeeInfo.registrationStart.subtract(const Duration(minutes: 15));

      final notification = NotificationModel(
        id: event.id,
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
    }

    Future unregisterNotification() async {
      willNotifyBeforeRegistration.value = false;

      flutterLocalNotificationsPlugin.show(
        0,
        'Varsling Av',
        'Du vil ikke lenger bli varslet før påmelding starter.',
        const NotificationDetails(
          iOS: DarwinNotificationDetails(),
        ),
      );

      await flutterLocalNotificationsPlugin.cancel(event.id);
    }

    return ValueListenableBuilder(
        valueListenable: willNotifyBeforeRegistration,
        builder: (context, willNotify, child) {
          final color = willNotify ? OnlineTheme.red : OnlineTheme.yellow;
          final text = willNotify ? 'Ikke Varsle Meg' : 'Varsle Før Påmelding';

          return AnimatedButton(
            onTap: () async {
              if (!willNotify) {
                await registerNotification();
              } else {
                await unregisterNotification();
              }
            },
            childBuilder: (context, hover, pointerDown) {
              return Container(
                height: OnlineTheme.buttonHeight,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.fromBorderSide(
                    BorderSide(color: color, width: 2),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: OnlineTheme.textStyle(
                    weight: 5,
                    color: color,
                  ),
                ),
              );
            },
          );
        });
  }

  final ValueNotifier<bool> willNotifyBeforeEventStart = ValueNotifier(false);

  Widget notifyAttendance() {
    Future eventStartNotification() async {
      willNotifyBeforeEventStart.value = true;

      final DateTime parsedStartDate = DateTime.parse(event.startDate);

      final scheduleNotificationDateTime = parsedStartDate.subtract(const Duration(minutes: 60));

      final notification = NotificationModel(
        id: event.id,
        time: scheduleNotificationDateTime,
        header: 'Arrangement starter snart!',
        body: '${event.title} starter om 1 time.',
      );

      flutterLocalNotificationsPlugin.show(
        0,
        'Varsling På',
        'Du vil bli varslet 1 time før arrangementet starter.',
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
    }

    Future eventEndNotification() async {
      willNotifyBeforeEventStart.value = false;

      flutterLocalNotificationsPlugin.show(
        0,
        'Varsling Av',
        'Du vil ikke lenger bli varslet før arrangementet starter.',
        const NotificationDetails(
          iOS: DarwinNotificationDetails(),
        ),
      );

      await flutterLocalNotificationsPlugin.cancel(event.id);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        ValueListenableBuilder(
            valueListenable: willNotifyBeforeEventStart,
            builder: (context, willNotify, child) {
              final color = willNotify ? OnlineTheme.red : OnlineTheme.yellow;
              final text = willNotify ? 'Ikke Varsle Meg' : 'Varsle Før Start';

              return AnimatedButton(
                onTap: () async {
                  if (willNotify) {
                    await eventEndNotification();
                  } else {
                    await eventStartNotification();
                  }
                },
                childBuilder: (context, hover, pointerDown) {
                  return Container(
                    height: OnlineTheme.buttonHeight,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.fromBorderSide(BorderSide(color: color, width: 2)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: OnlineTheme.textStyle(
                        weight: 5,
                        color: color,
                      ),
                    ),
                  );
                },
              );
            }),
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
