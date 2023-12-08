import 'package:flutter/material.dart';
import 'package:online_events/pages/event/cards/confirm_registration.dart';
import 'package:online_events/pages/event/cards/confirm_unattend.dart';

import '/components/animated_button.dart';
import '/components/separator.dart';
import '/main.dart';
import '/pages/event/show_participants.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

/// This appears to be the sus buttons on the bottom
class EventAttendees extends StatefulWidget {
  const EventAttendees({super.key});

  @override
  // ignore: library_private_types_in_public_api
  EventAttendeesButtonState createState() => EventAttendeesButtonState();
}

class EventAttendeesButtonState extends State<EventAttendees> {
  @override
  Widget build(BuildContext context) {
    double buttonHeight = 50;
    return Row(
      children: [
        Flexible(
          child: AnimatedButton(
            onTap: () {
              // Navigate to ShowParticipants regardless of isRegistered state
              AppNavigator.navigateToRoute(
                ShowParticipants(),
                additive: true,
              );
            },
            childBuilder: (context, hover, pointerDown) {
              return Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(gradient: OnlineTheme.blueGradient, borderRadius: const BorderRadius.all(Radius.circular(10))), // Use false for blue gradient
                child: Text('Se Påmeldte', style: OnlineTheme.textStyle()),
              );
            },
          ),
        ),
      ],
    );
  }
}
