import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';
import '/pages/event/show_participants.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

/// This appears to be the sus buttons on the bottom
class EventAttendees extends StatefulWidget {
  const EventAttendees({super.key, required this.model, required this.attendeeInfoModel});

  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;

  @override
  // ignore: library_private_types_in_public_api
  EventAttendeesButtonState createState() => EventAttendeesButtonState();
}

class EventAttendeesButtonState extends State<EventAttendees> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: AnimatedButton(
        onTap: () {
          // Navigate to ShowParticipants regardless of isRegistered state
          PageNavigator.navigateTo(ShowParticipants(
            model: widget.model,
            attendeeInfoModel: widget.attendeeInfoModel,
          ));
        },
        childBuilder: (context, hover, pointerDown) {
          return Container(
            alignment: Alignment.center,
            height: 50,
            decoration: BoxDecoration(
                gradient: OnlineTheme.blueGradient,
                borderRadius: const BorderRadius.all(Radius.circular(10))), // Use false for blue gradient
            child: Text('Se Påmeldte', style: OnlineTheme.textStyle()),
          );
        },
      ),
    );
  }
}
