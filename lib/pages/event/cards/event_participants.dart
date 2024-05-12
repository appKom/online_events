import 'package:flutter/material.dart';
import 'package:online/theme/themed_icon.dart';

import '../participant_overlay.dart';
import '/components/separator.dart';
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

  /// This badge shows your registration status.
  /// If the badge is green, you are registered.
  /// If the badge is yellow, you are on a waitlist.
  /// If the badge is gray, you are neither.
  ({Color border, Color fill, Color icon}) yourStatus() {
    final theme = OnlineTheme.current;

    // You are on the waitlist
    if (attendeeInfoModel.isOnWaitlist) {
      return (
        border: theme.wait,
        fill: theme.waitBg,
        icon: theme.waitFg,
      );
    }

    // You are registered
    if (attendeeInfoModel.isAttendee) {
      return (
        border: theme.pos,
        fill: theme.posBg,
        icon: theme.posFg,
      );
    }

    // You are neither registered nor on the waitlist
    return (
      border: theme.fg,
      fill: theme.bg,
      icon: theme.fg,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColors = yourStatus();

    return SizedBox(
      height: 60,
      child: GestureDetector(
        onTap: () {
          ParticipantOverlay(model: model, attendeeInfoModel: attendeeInfoModel).show(context);
        },
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
                    color: statusColors.fill,
                    borderRadius: OnlineTheme.buttonRadius,
                    border: Border.fromBorderSide(BorderSide(color: statusColors.border, width: 2)),
                  ),
                  alignment: Alignment.center,
                  child: ThemedIcon(
                    icon: IconType.usersFilled,
                    size: 16,
                    color: statusColors.icon,
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
                      style: OnlineTheme.textStyle(size: 15),
                    ),
                    Text(
                      peopleToString(),
                      style: OnlineTheme.textStyle(size: 15),
                    ),
                  ],
                ),
              ),
              const Separator(axis: Axis.vertical, length: 60, margin: 10),
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
                      style: OnlineTheme.textStyle(size: 15),
                      overflow: TextOverflow.visible,
                    ),
                    Center(
                      child: Text(
                        waitlistInfo(),
                        style: OnlineTheme.textStyle(size: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
