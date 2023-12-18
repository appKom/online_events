import 'package:flutter/material.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/event_model.dart';

import '/components/animated_button.dart';
import '/main.dart';
import '/pages/event/show_participants.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'package:online_events/core/client/client.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

bool isRegistered = false;

/// This appears to be the sus buttons on the bottom
class EventCardButtons extends StatefulWidget {
  const EventCardButtons(
      {super.key, required this.model, required this.attendeeInfoModel});

  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;

  @override
  // ignore: library_private_types_in_public_api
  _EventCardButtonsState createState() => _EventCardButtonsState();
}

class _EventCardButtonsState extends State<EventCardButtons> {
  Future<void> registerForEvent(String eventId) async {
    final String apiUrl =
        'https://old.online.ntnu.no/api/v1/event/attendance-events/$eventId/register/';

    // Your request body
    final Map<String, dynamic> requestBody = {
      "recaptcha":
          "your_recaptcha_token_here", // You might need to handle recaptcha
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
        print("Successfully registered for the event");
      } else {
        // Handle error
        print("Failed to register for the event: ${response.body}");
      }
    } catch (e) {
      // Handle any exceptions
      print("Error occurred: $e");
    }
  }

  Future<void> unregisterForEvent(String eventId) async {
    final String apiUrl =
        'https://old.online.ntnu.no/api/v1/event/attendance-events/$eventId/unregister/';

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

  @override
  Widget build(BuildContext context) {
    double buttonHeight = 50;
    return Row(
      children: [
        if (widget.attendeeInfoModel.isEligibleForSignup.status == true &&
            loggedIn == true)
          Flexible(
            child: AnimatedButton(
              onTap: () {
                registerForEvent(widget.model.id.toString());
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  alignment: Alignment.center,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                      gradient: OnlineTheme.greenGradient,
                      borderRadius: OnlineTheme.eventButtonRadius),
                  child: Text(
                    'Meld meg på',
                    style: OnlineTheme.textStyle(),
                  ),
                );
              },
            ),
          ),
        const SizedBox(
          width: 10,
        ),
        if (widget.attendeeInfoModel.isAttendee == true &&
            widget.attendeeInfoModel.unattendDeadline.isAfter(DateTime.now()) &&
            loggedIn == true)
          Flexible(
            child: AnimatedButton(
              onTap: () {
                unregisterForEvent(widget.model.id.toString());
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  alignment: Alignment.center,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                      gradient: OnlineTheme.redGradient,
                      borderRadius: OnlineTheme.eventButtonRadius),
                  child: Text(
                    'Meld av',
                    style: OnlineTheme.textStyle(),
                  ),
                );
              },
            ),
          ),
        if (widget.attendeeInfoModel.isEligibleForSignup.statusCode == 503 &&
            loggedIn == true)
          Flexible(
            child: AnimatedButton(
              onTap: () {
                registerForEvent(widget.model.id.toString());
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: const BoxDecoration(
                      gradient: OnlineTheme.yellowGradient,
                      borderRadius: OnlineTheme.eventButtonRadius),
                  child: Text('Meld på venteliste',
                      style: OnlineTheme.textStyle()),
                );
              },
            ),
          ),
        const SizedBox(
          width: 10,
        ),
        if (widget.attendeeInfoModel.isEligibleForSignup.statusCode == 501)
          Flexible(
            child: AnimatedButton(
              onTap: () {
                //TODO Noe skal skje her
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: const BoxDecoration(
                      gradient: OnlineTheme.purpleGradient,
                      borderRadius: OnlineTheme.eventButtonRadius),
                  child: Text('Varsle meg', style: OnlineTheme.textStyle()),
                );
              },
            ),
          ),
        const SizedBox(
          width: 10,
        ),
        if (widget.attendeeInfoModel.registrationStart
                .isBefore(DateTime.now()) &&
            loggedIn == true &&
            widget.attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
          Flexible(
            child: AnimatedButton(
              onTap: () {
                // Navigate to ShowParticipants regardless of isRegistered state
                PageNavigator.navigateTo(
                  ShowParticipants(
                      model: widget.model,
                      attendeeInfoModel: widget.attendeeInfoModel),
                );
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: const BoxDecoration(
                      gradient: OnlineTheme.blueGradient,
                      borderRadius: OnlineTheme.eventButtonRadius),
                  child: Text('Se Påmeldte', style: OnlineTheme.textStyle()),
                );
              },
            ),
          ),
      ],
    );
  }
}
