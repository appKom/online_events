import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:online/services/online_toast.dart';

import '/components/animated_button.dart';
import '/core/client/client.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';
import '/main.dart';
import '/pages/event/cards/recaptcha.dart';
import '/pages/event/event_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

bool isRegistered = false;

/// This appears to be the sus buttons on the bottom
class EventCardButtons extends StatefulWidget {
  const EventCardButtons({
    super.key,
    required this.model,
    required this.attendeeInfoModel,
    required this.onUnregisterSuccess,
  });

  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;
  final VoidCallback onUnregisterSuccess;

  @override
  // ignore: library_private_types_in_public_api
  _EventCardButtonsState createState() => _EventCardButtonsState();
}

class _EventCardButtonsState extends State<EventCardButtons> {
  Future<void> unregisterForEvent(String eventId) async {
    final String apiUrl = 'https://old.online.ntnu.no/api/v1/event/attendance-events/$eventId/unregister/';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${Client.accessToken}',
        },
      );

      if (response.statusCode == 204) {
        // Handle successful unregistration
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          const SnackBar(content: Text("Du har blitt avmeldt arrangementet")),
        );
        widget.onUnregisterSuccess(); // Call the callback
        print("Successfully unregistered from the event");
      } else {
        // Handle error
        print("Failed to unregister from the event: ${response.body}");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
    }
  }

  /// Select appropriate button.
  Widget selectButton() {
    if (canWaitlist()) return waitlistButton();
    if (canRegister()) return registerButton();
    if (canUnregister()) return unregisterButton(true);
    if (canNotify()) return notifyButton();

    return Container();
  }

  /// Can the user sign up for waitlist?
  bool canWaitlist() {
    // User not logged in
    if (!loggedIn) return false;

    // No waitlist to register to
    if (!widget.attendeeInfoModel.waitlist) return false;

    // If user is already signed up
    if (widget.attendeeInfoModel.isAttendee) return false;

    // Still available spots - no waitlist yet
    if (widget.attendeeInfoModel.numberOfSeatsTaken < widget.attendeeInfoModel.maxCapacity) return false;

    // Registration has ended
    if (widget.attendeeInfoModel.registrationEnd.isBefore(DateTime.now())) return false;

    return true;
  }

  /// Can the user register at the event?
  bool canRegister() {
    // User not logged in
    if (!loggedIn) return false;

    // User not eligible for signup
    if (!widget.attendeeInfoModel.isEligibleForSignup.status) return false;

    // Registration has ended
    if (widget.attendeeInfoModel.registrationEnd.isBefore(DateTime.now())) return false;

    return true;
  }

  bool canUnregister() {
    // User not logged in
    if (!loggedIn) return false;

    // User not registered for this event
    if (!widget.attendeeInfoModel.isAttendee) return false;

    // May still want to show the unregister button, just grayed out
    if (widget.attendeeInfoModel.unattendDeadline.isBefore(DateTime.now())) return false;

    return true;
  }

  bool canNotify() {

    // If registration has not started
    if (widget.attendeeInfoModel.registrationStart.isBefore(DateTime.now())) return false;

    return true;
  }

  Widget registerButton() {
    return AnimatedButton(
      onTap: () {
        // TODO Midlertidig fiks, burde fikse reCaptcha inne i appen
        AppNavigator.navigateToPage(ReCaptchaDisplay(
          model: widget.model,
        ));
        // registerForEvent(widget.model.id.toString());
      },
      childBuilder: (context, hover, pointerDown) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // gradient: OnlineTheme.greenGradient,
            color: OnlineTheme.green.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5),
            border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.green, width: 2)),
          ),
          child: Text(
            'Meld På',
            style: OnlineTheme.textStyle(weight: 5, color: OnlineTheme.green),
          ),
        );
      },
    );
  }

  // TODO: At the moment, there are no cases where button will be shown when disabled, but maybe one day
  Widget unregisterButton(bool enabled) {
    final fill = enabled ? OnlineTheme.red.withOpacity(0.4) : Colors.transparent;
    final border = enabled ? OnlineTheme.red : OnlineTheme.grayBorder;

    return AnimatedButton(
      onTap: enabled
          ? () {
              unregisterForEvent(widget.model.id.toString());
            }
          : null,
      childBuilder: (context, hover, pointerDown) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: fill,
            border: Border.fromBorderSide(BorderSide(color: border, width: 2)),
          ),
          child: Text(
            'Meld Av',
            style: OnlineTheme.textStyle(
              weight: 5,
              color: border,
            ),
          ),
        );
      },
    );
  }

  Widget waitlistButton() {
    return AnimatedButton(
      onTap: () {
        AppNavigator.navigateToPage(ReCaptchaDisplay(
          model: widget.model,
        ));
      },
      childBuilder: (context, hover, pointerDown) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: OnlineTheme.yellow.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.0),
            border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.yellow, width: 2)),
          ),
          child: Text(
            'Meld På Venteliste',
            style: OnlineTheme.textStyle(
              weight: 5,
              color: OnlineTheme.yellow,
            ),
          ),
        );
      },
    );
  }

  Widget notifyButton() {
    return AnimatedButton(
      onTap: () async{
        final DateTime scheduleNotificationDateTime = widget.attendeeInfoModel.registrationStart.subtract(const Duration(minutes: 15));
      const int notificationId = 0;
      const String channelId = "your_channel_id";
      const String channelName = "Notification Channel";
      const String channelDescription = "Channel for event registration reminder";

      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );
      var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        'Påmelding starter snart!',
        'Påmelding til ${widget.model.title} starter om 15 minutter.',
        tz.TZDateTime.from(scheduleNotificationDateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true, 
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, 
      );

      OnlineToast.show("Du vil bli varslet 15 minutter før påmelding starter");
    },
      
      childBuilder: (context, hover, pointerDown) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: OnlineTheme.purple1.withOpacity(0.4),
            borderRadius: BorderRadius.circular(5.0),
            border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.purple1, width: 2)),
          ),
          child: Text(
            'Varsle meg',
            style: OnlineTheme.textStyle(
              weight: 5,
              color: OnlineTheme.white,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return selectButton();
  }
}
