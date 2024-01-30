import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/error/error_handling.dart';
import '/components/animated_button.dart';
import '/core/client/client.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';
import '/main.dart';
import '/pages/event/cards/recaptcha.dart';
import '/pages/event/event_page.dart';
import '/services/app_navigator.dart';
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
  Future<void> registerForEvent(String eventId) async {
    final String apiUrl = 'https://old.online.ntnu.no/api/v1/event/attendance-events/$eventId/register/';

    // Your request body
    final Map<String, dynamic> requestBody = {
      "recaptcha": "onlineweb4.fields.recaptcha.validate_recaptcha", // You might need to handle recaptcha
      "allow_pictures": true,
      "show_as_attending_event": true,
      "note": "" // Any additional note if required
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${Client.accessToken}',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        // Handle successful registration

        ErrorHandling.showErrorTop("Du er registrert");
      } else {
        // Handle error
        ErrorHandling.showErrorTop("Greide ikke å registrere: ${response.body}");
      }
    } catch (e) {
      // Handle any exceptions
      ErrorHandling.showErrorTop("En error har skjedd: $e");
    }
  }

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
    // if (!widget.attendeeInfoModel.isEligibleForSignup.status) return Container();
    // if (!loggedIn) return Container();

    if (canWaitlist()) return waitlistButton();
    if (canRegister()) return registerButton();
    if (canUnregister()) return unregisterButton(true);

    return Container();
    // if (widget.model.maxCapacity == null || widget.model.)
    // if (widget.model.) return waitlistButton();
  }

  /// Can the user sign up for waitlist?
  bool canWaitlist() {
    // User not logged in
    if (!loggedIn) return false;

    // No waitlist to register to
    if (!widget.attendeeInfoModel.waitlist) return false;

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

  Widget registerButton() {
    return AnimatedButton(
      onTap: () {
        // TODO Midlertidig fiks, burde fikse reCaptcha inne i appen
        PageNavigator.navigateTo(ReCaptchaDisplay(
          model: widget.model,
        ));
      },
      childBuilder: (context, hover, pointerDown) {
        return Container(
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
        registerForEvent(widget.model.id.toString());
      },
      childBuilder: (context, hover, pointerDown) {
        return Container(
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

  @override
  Widget build(BuildContext context) {
    const height = 40.0;
    final radius = BorderRadius.circular(5.0);

    return selectButton();

    return SizedBox(
      height: height,
      child: Row(
        children: [
          if (widget.attendeeInfoModel.isEligibleForSignup.status == true && loggedIn == true)
            Flexible(
              child: AnimatedButton(
                onTap: () {
                  // TODO Midlertidig fiks, burde fikse reCaptcha inne i appen
                  PageNavigator.navigateTo(ReCaptchaDisplay(
                    model: widget.model,
                  ));
                },
                childBuilder: (context, hover, pointerDown) {
                  return Container(
                    alignment: Alignment.center,
                    height: height,
                    decoration: BoxDecoration(
                      // gradient: OnlineTheme.greenGradient,
                      color: OnlineTheme.green.withOpacity(0.4),
                      borderRadius: radius,
                      border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.green, width: 2)),
                    ),
                    child: Text(
                      'Meld På',
                      style: OnlineTheme.textStyle(weight: 5, color: OnlineTheme.green),
                    ),
                  );
                },
              ),
            ),
          if (widget.attendeeInfoModel.isAttendee &&
              widget.attendeeInfoModel.unattendDeadline.isAfter(DateTime.now()) &&
              loggedIn)
            Flexible(
              child: AnimatedButton(
                onTap: () {
                  unregisterForEvent(widget.model.id.toString());
                },
                childBuilder: (context, hover, pointerDown) {
                  return Container(
                    alignment: Alignment.center,
                    height: height,
                    decoration: BoxDecoration(
                      // gradient: OnlineTheme.redGradient,
                      borderRadius: radius,
                      color: OnlineTheme.red.withOpacity(0.4),
                      border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.red, width: 2)),
                    ),
                    child: Text(
                      'Meld Av',
                      style: OnlineTheme.textStyle(weight: 5, color: OnlineTheme.red),
                    ),
                  );
                },
              ),
            ),
          if (widget.attendeeInfoModel.isEligibleForSignup.statusCode == 503 && loggedIn)
            Flexible(
              child: AnimatedButton(
                onTap: () {
                  registerForEvent(widget.model.id.toString());
                },
                childBuilder: (context, hover, pointerDown) {
                  return Container(
                    alignment: Alignment.center,
                    height: 50,
                    decoration: BoxDecoration(
                      color: OnlineTheme.yellow.withOpacity(0.4),
                      borderRadius: radius,
                      border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.red, width: 2)),
                    ),
                    child: Text('Meld På Venteliste', style: OnlineTheme.textStyle()),
                  );
                },
              ),
            ),
          // const SizedBox(
          //   width: 10,
          // ),
          // if (widget.attendeeInfoModel.isEligibleForSignup.statusCode == 501)
          //   Flexible(
          //     child: AnimatedButton(
          //       onTap: () {
          //         //TODO Noe skal skje her
          //       },
          //       childBuilder: (context, hover, pointerDown) {
          //         return Container(
          //           alignment: Alignment.center,
          //           height: height,
          //           decoration: BoxDecoration(
          //             gradient: OnlineTheme.purpleGradient,
          //             borderRadius: radius,
          //           ),
          //           child: Text('Varsle meg', style: OnlineTheme.textStyle()),
          //         );
          //       },
          //     ),
          //   ),
          // const SizedBox(
          //   width: 10,
          // ),
          // if (widget.attendeeInfoModel.registrationStart.isBefore(DateTime.now()) &&
          //     loggedIn == true &&
          //     widget.attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
          //   Flexible(
          //     child: AnimatedButton(
          //       onTap: () {
          //         // Navigate to ShowParticipants regardless of isRegistered state
          //         PageNavigator.navigateTo(
          //           ShowParticipants(model: widget.model, attendeeInfoModel: widget.attendeeInfoModel),
          //         );
          //       },
          //       childBuilder: (context, hover, pointerDown) {
          //         return Container(
          //           alignment: Alignment.center,
          //           height: height,
          //           decoration: const BoxDecoration(
          //             gradient: OnlineTheme.blueGradient,
          //             borderRadius: OnlineTheme.eventButtonRadius,
          //           ),
          //           child: Text('Se Påmeldte', style: OnlineTheme.textStyle()),
          //         );
          //       },
          //     ),
          //   ),
        ],
      ),
    );
  }
}
