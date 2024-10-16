import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:online/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const channelDescription = "Reminders about widget.event registrations and widget.event starts.";

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

class AttendanceCard extends StatefulWidget {
  final EventModel event;
  final AttendeeInfoModel attendeeInfo;

  const AttendanceCard({super.key, required this.event, required this.attendeeInfo});

  @override
  AttendanceCardState createState() => AttendanceCardState();
}

class AttendanceCardState extends State<AttendanceCard> {
  late final String _notificationPrefKeyBeforeRegistration;
  late final String _notificationPrefKeyBeforeEventStart;
  bool isAlreadyNotified = false;

  @override
  void initState() {
    super.initState();
    _notificationPrefKeyBeforeRegistration = 'notifyBeforeRegistration_${widget.event.id}';
    _notificationPrefKeyBeforeEventStart = 'notifyBeforeEventStart_${widget.event.id}';
    _loadNotificationPrefs();
  }

  Future<void> _loadNotificationPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    willNotifyBeforeRegistration.value = prefs.getBool(_notificationPrefKeyBeforeRegistration) ?? false;
    willNotifyBeforeEventStart.value = prefs.getBool(_notificationPrefKeyBeforeEventStart) ?? false;
    for (var category in eventCategories.keys) {
      eventCategories[category] = prefs.getBool(category) ?? false;
    }

    if (widget.event.eventType == 2 && prefs.getBool('Bedriftspresentasjoner') == true) {
      isAlreadyNotified = true;
    } else if (widget.event.eventType == 3 && prefs.getBool('Kurs') == true) {
      isAlreadyNotified = true;
    } else if (widget.event.eventType == 1 && prefs.getBool('Sosialt') == true) {
      isAlreadyNotified = true;
    } else if (widget.event.eventType != 1 &&
        widget.event.eventType != 2 &&
        widget.event.eventType != 3 &&
        prefs.getBool('Annet') == true) {
      isAlreadyNotified = true;
    }
    print('isAlreadyNotified: $isAlreadyNotified');
  }

  Future<void> _saveNotificationPref(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  bool showCountdownToRegistrationStart() {
    // Registration has started - no need for a countdown
    if (DateTime.now().isAfter(widget.attendeeInfo.registrationStart)) return false;

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
        EventCardCountdown(eventTime: widget.attendeeInfo.registrationStart),
        const SizedBox(height: 24),
        if (isAlreadyNotified == false) notifyEventRegistration(),
        if (isAlreadyNotified) isAlreadyNotifiedWidget(),
      ],
    );
  }

  bool showCountdownToEventStart() {
    final eventDateTime = DateTime.parse(widget.event.startDate);

    // Registration is still open - don't show countdown yet
    if (widget.attendeeInfo.registrationEnd.isAfter((DateTime.now()))) return false;

    // Event has already started
    if (DateTime.now().isAfter(eventDateTime)) return false;

    return true;
  }

  Widget countdownToEventStart() {
    final eventDateTime = DateTime.parse(widget.event.startDate);

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

  final Map<String, bool> eventCategories = {
    'Bedriftspresentasjoner': false,
    'Kurs': false,
    'Sosialt': false,
    'Annet': false,
  };

  Widget isAlreadyNotifiedWidget() {
    String eventType = '';

    if (widget.event.eventTypeDisplay == 'Kurs') {
      eventType = 'for alle kurs';
    } else if (widget.event.eventTypeDisplay == 'Bedriftspresentasjoner') {
      eventType = 'for alle bedpresser';
    } else if (widget.event.eventTypeDisplay == 'Sosialt') {
      eventType = 'for sosiale arrangementer';
    } else {
      eventType = 'for arrangementet';
    }
    return Container(
      height: OnlineTheme.buttonHeight,
      decoration: BoxDecoration(
        color: OnlineTheme.gray15.withOpacity(0.4),
        borderRadius: BorderRadius.circular(5.0),
        border: const Border.fromBorderSide(
          BorderSide(color: OnlineTheme.gray15, width: 2),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        'Varsling på ${eventType.toLowerCase()}',
        style: OnlineTheme.textStyle(
          weight: 5,
          color: OnlineTheme.current.fg,
        ),
      ),
    );
  }

  Widget notifyEventRegistration() {
    Future registerNotification() async {
      await _saveNotificationPref(_notificationPrefKeyBeforeRegistration, true);
      willNotifyBeforeRegistration.value = true;

      final scheduleNotificationDateTime = widget.attendeeInfo.registrationStart.subtract(const Duration(minutes: 15));

      final notification = NotificationModel(
        id: widget.event.id,
        time: scheduleNotificationDateTime,
        header: 'Påmelding Snart!',
        body: 'Påmelding til ${widget.event.title} starter om 15 minutter.',
      );

      if (Platform.isIOS) {
        flutterLocalNotificationsPlugin.show(
          0,
          'Varsling På',
          'Du vil bli varslet 15 min før påmelding starter.',
          const NotificationDetails(
            iOS: DarwinNotificationDetails(),
          ),
        );
      }
      if (Platform.isAndroid) print("Varsling På");

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
      await _saveNotificationPref(_notificationPrefKeyBeforeRegistration, false);
      willNotifyBeforeRegistration.value = false;

      if (Platform.isIOS) {
        flutterLocalNotificationsPlugin.show(
          0,
          'Varsling Av',
          'Du vil ikke lenger bli varslet før påmelding starter.',
          const NotificationDetails(
            iOS: DarwinNotificationDetails(),
          ),
        );
      }

      if (Platform.isAndroid) print("Varsling Av");

      await flutterLocalNotificationsPlugin.cancel(widget.event.id);
    }

    final theme = OnlineTheme.current;

    return ValueListenableBuilder(
        valueListenable: willNotifyBeforeRegistration,
        builder: (context, willNotify, child) {
          final bg = willNotify ? theme.negBg : theme.waitBg;
          final border = willNotify ? theme.neg : theme.wait;
          final fg = willNotify ? theme.negFg : theme.waitFg;

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
                  color: bg,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.fromBorderSide(
                    BorderSide(color: border, width: 2),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: OnlineTheme.textStyle(
                    weight: 5,
                    color: fg,
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
      await _saveNotificationPref(_notificationPrefKeyBeforeEventStart, true);
      willNotifyBeforeEventStart.value = true;

      final DateTime parsedStartDate = DateTime.parse(widget.event.startDate);

      final scheduleNotificationDateTime = parsedStartDate.subtract(const Duration(minutes: 60));

      final notification = NotificationModel(
        id: widget.event.id,
        time: scheduleNotificationDateTime,
        header: 'Arrangement starter snart!',
        body: '${widget.event.title} starter om 1 time.',
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
      await _saveNotificationPref(_notificationPrefKeyBeforeEventStart, false);
      willNotifyBeforeEventStart.value = false;

      var notificationDetails = const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'event_reminders_channel',
          'Avmeldelt varsling',
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        'Varsling Av',
        'Du vil ikke lenger bli varslet før arrangementet starter.',
        notificationDetails,
      );

      await flutterLocalNotificationsPlugin.cancel(widget.event.id);
    }

    final theme = OnlineTheme.current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        ValueListenableBuilder(
            valueListenable: willNotifyBeforeEventStart,
            builder: (context, willNotify, child) {
              final bg = willNotify ? theme.negBg : theme.waitBg;
              final border = willNotify ? theme.neg : theme.wait;
              final fg = willNotify ? theme.negFg : theme.waitFg;
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
                      color: bg,
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.fromBorderSide(BorderSide(color: border, width: 2)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style: OnlineTheme.textStyle(
                        weight: 5,
                        color: fg,
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
    _loadNotificationPrefs();
    return OnlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ThemedIcon(icon: IconType.dateTime, size: 20),
              const SizedBox(width: 8),
              Text(
                EventDateFormatter.formatEventDates(widget.event.startDate, widget.event.endDate),
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
                ThemedIcon(icon: IconType.location, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.event.location,
                  style: OnlineTheme.textStyle(),
                  softWrap: true,
                ),
              ],
            ),
          ),
          if (showCountdownToRegistrationStart()) countdownToRegistrationStart(),
          if (showCountdownToEventStart()) countdownToEventStart(),
          if (widget.attendeeInfo.isAttendee && DateTime.parse(widget.event.endDate).isAfter(DateTime.now()))
            notifyAttendance(),
        ],
      ),
    );
  }
}
