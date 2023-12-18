import 'package:flutter/material.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/event_model.dart';

import '/components/animated_button.dart';
import '/components/separator.dart';
import '/main.dart';
import '/pages/event/show_participants.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

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
  @override
  Widget build(BuildContext context) {
    double buttonHeight = 50;
    return Row(
      children: [
        if (widget.attendeeInfoModel.isEligibleForSignup.status == true && loggedIn == true)
        Flexible(
          child: AnimatedButton(
            onTap: () {
              //TODO at noe faktisk skjer her
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
        if (widget.attendeeInfoModel.isAttendee == true && widget.attendeeInfoModel.unattendDeadline.isAfter(DateTime.now()) && loggedIn == true)
        Flexible(
          child: AnimatedButton(
            onTap: () {
              //TODO At noe skjer her
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
        if (widget.attendeeInfoModel.isEligibleForSignup.statusCode == 503 && loggedIn == true)
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
                    gradient: OnlineTheme.yellowGradient,
                    borderRadius: OnlineTheme.eventButtonRadius),
                child: Text('Meld på venteliste', style: OnlineTheme.textStyle()),
              );
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        if (loggedIn == false && widget.attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
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
        if (widget.attendeeInfoModel.registrationStart.isBefore(DateTime.now()) && loggedIn == true)
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
