import 'package:flutter/material.dart';
import 'package:online_events/components/separator.dart';

import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';
import '/theme/theme.dart';

class EventParticipants extends StatelessWidget {
  const EventParticipants({super.key, required this.model, required this.attendeeInfoModel});

  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;

  String peopleToString() {
    if (model.maxCapacity == null) return 'Ubegrenset';

    return '${model.numberOfSeatsTaken}/${model.maxCapacity}';
  }

  String waitlistInfo() {
    if (attendeeInfoModel.isOnWaitlist) {
      return '${attendeeInfoModel.whatPlaceIsUserOnWaitList}/${attendeeInfoModel.numberOnWaitlist}';
    } else {
      return '${attendeeInfoModel.numberOnWaitlist}';
    }
  }

  Color trafficLight() {
    // Yellow if you are on waitlist
    if (attendeeInfoModel.isOnWaitlist) return OnlineTheme.yellow;

    // Green if infinite capacity
    if (model.maxCapacity == null) return OnlineTheme.green;

    // Green if more seats available
    if (model.numberOfSeatsTaken! < model.maxCapacity!) return OnlineTheme.green;

    // Red otherwise
    return OnlineTheme.red;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = trafficLight();

    return Container(
      height: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10), // Add space between icon and text
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.fromBorderSide(BorderSide(color: statusColor, width: 2)),
                ),
                child: Center(
                  child: Icon(
                    Icons.people_alt,
                    size: 20,
                    color: statusColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Align children in the center vertically
                children: [
                  Text(
                    'Påmeldte',
                    style: OnlineTheme.textStyle(size: 14),
                  ),
                  Text(
                    peopleToString(),
                    style: OnlineTheme.textStyle(size: 14),
                  ),
                ],
              ),
            ),
            const Separator(axis: Axis.vertical, length: 40, margin: 10),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // Align children in the center vertically
                children: [
                  Text(
                    'Venteliste',
                    style: OnlineTheme.textStyle(size: 14),
                    overflow: TextOverflow.visible,
                  ),
                  Center(
                    child: Text(
                      waitlistInfo(),
                      style: OnlineTheme.textStyle(size: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
