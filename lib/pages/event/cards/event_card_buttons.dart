import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:online/services/authenticator.dart';

import '/components/animated_button.dart';
import '/core/client/client.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';
import '/theme/theme.dart';

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
  Future<void> unregisterForEvent(int eventId, BuildContext context) async {
    final String apiUrl = 'https://old.online.ntnu.no/api/v1/event/attendance-events/$eventId/unregister/';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${Authenticator.credentials!.accessToken}',
        },
      );

      if (response.statusCode == 204) {
        // TODO: More sophisticated approach of doing this

        widget.onUnregisterSuccess(); // Call the callback

        if (context.mounted) {
          final dir = GoRouter.of(context).routeInformationProvider.value.uri.toString();
          context.go(dir);
        }
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

    return Container();
  }

  /// Can the user sign up for waitlist?
  bool canWaitlist() {
    // User not logged in
    if (!Authenticator.isLoggedIn()) return false;

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
    if (!Authenticator.isLoggedIn()) return false;

    // User not eligible for signup
    if (!widget.attendeeInfoModel.isEligibleForSignup.status) return false;

    // Registration has ended
    if (widget.attendeeInfoModel.registrationEnd.isBefore(DateTime.now())) return false;

    return true;
  }

  bool canUnregister() {
    // User not logged in
    if (!Authenticator.isLoggedIn()) return false;

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
    final theme = OnlineTheme.current;

    return AnimatedButton(
      onTap: () {
        Client.launchInBrowser('https://online.ntnu.no/events/${widget.model.id}');
      },
      childBuilder: (context, hover, pointerDown) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // gradient: OnlineTheme.greenGradient,
            color: theme.posBg,
            borderRadius: BorderRadius.circular(5),
            border: Border.fromBorderSide(BorderSide(color: theme.pos, width: 2)),
          ),
          child: Text(
            'Meld På',
            style: OnlineTheme.textStyle(weight: 5, color: theme.posFg),
          ),
        );
      },
    );
  }

  Future<void> showUnregisterDialog() async {
    final result = await FlutterPlatformAlert.showCustomAlert(
      windowTitle: 'Bekreft avmelding',
      text: 'Er du sikker på at du vil melde deg av?',
      iconStyle: IconStyle.warning,
      negativeButtonTitle: 'Meld av',
      neutralButtonTitle: 'Avbryt',
      options: PlatformAlertOptions(
        windows: WindowsAlertOptions(preferMessageBox: true),
      ),
    );

    if (result == CustomButton.negativeButton) {
      unregisterForEvent(widget.model.id, context);
    }
  }

  // TODO: At the moment, there are no cases where button will be shown when disabled, but maybe one day
  Widget unregisterButton(bool enabled) {
    // final fill = enabled ? OnlineTheme.red.withOpacity(0.4) : Colors.transparent;
    // final border = enabled ? OnlineTheme.red : OnlineTheme.grayBorder;

    final theme = OnlineTheme.current;

    final bg = enabled ? theme.negBg : theme.muted;
    final border = enabled ? theme.neg : theme.muted;
    final fg = enabled ? theme.negFg : theme.mutedForeground;

    return AnimatedButton(
      onTap: enabled ? showUnregisterDialog : null,
      childBuilder: (context, hover, pointerDown) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: bg,
            border: Border.fromBorderSide(BorderSide(color: border, width: 2)),
          ),
          child: Text(
            'Meld Av',
            style: OnlineTheme.textStyle(
              weight: 5,
              color: fg,
            ),
          ),
        );
      },
    );
  }

  Widget waitlistButton() {
    final theme = OnlineTheme.current;

    return AnimatedButton(
      onTap: () {
        Client.launchInBrowser('https://online.ntnu.no/events/${widget.model.id}');
      },
      childBuilder: (context, hover, pointerDown) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.waitBg,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.fromBorderSide(BorderSide(color: theme.wait, width: 2)),
          ),
          child: Text(
            'Meld På Venteliste',
            style: OnlineTheme.textStyle(
              weight: 5,
              color: theme.waitFg,
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
