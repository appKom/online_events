import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/pages/event/event_page.dart';
import 'package:online_events/pages/event/event_page_loggedin.dart';
import 'package:online_events/pages/profile/profile_page.dart';

import '/services/page_navigator.dart';
import '/pages/home/event_card.dart';
import '/theme/themed_icon.dart';

import '../../theme/theme.dart';

class BedpressLoggedIn extends StatelessWidget {
  const BedpressLoggedIn({
    super.key,
    required this.models,
  });

  final List<EventModel> models;

  @override
  Widget build(BuildContext context) {
    // Filter models where eventType is 2 and 3
    final filteredModels = models
        .where((model) => model.eventType == 2 || model.eventType == 3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Bedriftpresentasjoner og Kurs',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 333,
          child: ListView.builder(
            itemCount: filteredModels.length, // Use count of filtered models
            itemBuilder: (c, i) {
              return Padding(
                padding: EdgeInsets.only(
                    right: i < filteredModels.length - 1 ? 24 : 0),
                child: BedpressCardLoggedIn(
                  model: filteredModels[i], // Use filtered model
                  attendeeInfoModel: attendeeInfoModels[
                      i], // Assuming attendeeInfoModels is correctly aligned with filteredModels
                  attendeeInfoModels: attendeeInfoModels,
                ),
              );
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }
}

class BedpressCardLoggedIn extends StatelessWidget {
  const BedpressCardLoggedIn(
      {super.key,
      required this.model,
      required this.attendeeInfoModel,
      required this.attendeeInfoModels});

  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;
  final List<AttendeeInfoModel> attendeeInfoModels;

  // Example of a method to format the date
  String formatDate() {
    final date = DateTime.parse(model.startDate);
    final month = date.month;
    final day = date.day.toString().padLeft(2, '0');
    return "$day. ${EventCard.months[month - 1].substring(0, 3)}";
  }

  String truncateWithEllipsis(String text, int maxLength) {
    return (text.length <= maxLength)
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  void showInfo() {
    AttendeeInfoModel? matchingAttendeeInfo =
        attendeeInfoModels.firstWhereOrNull(
      (attendeeInfo) => attendeeInfo.id == model.id,
    );

    if (matchingAttendeeInfo != null) {
      PageNavigator.navigateTo(EventPageLoggedIn(
          model: model, attendeeInfoModel: matchingAttendeeInfo));
    } else {
      // Handle the case where no matching ID is found
      PageNavigator.navigateTo(EventPageLoggedIn(
          model: model, attendeeInfoModel: DEFAULT_ATTENDEE_MODEL));
    }
  }

  String getEventTypeDisplay() {
    // Check if the eventTypeDisplay is 'Bedriftspresentasjon'
    return model.eventTypeDisplay == 'Bedriftspresentasjon'
        ? 'Bedpres'
        : model.eventTypeDisplay;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: showInfo,
      childBuilder: (context, hover, pointerDown) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 222,
            color: OnlineTheme.gray13,
            child: Stack(
              children: [
                // Use first image from images list, with a fallback
                Positioned.fill(
                  //model.images.first.md
                  bottom: 111,
                  child: model.images.isNotEmpty
                      ? Image.network(
                          model.images.first.md,
                          fit: BoxFit.cover,
                        )
                      : SvgPicture.asset(
                          'assets/svg/online_hvit_o.svg', // Replace with your default image asset path
                          fit: BoxFit.cover,
                        ),
                  // child: Image.network(
                  //   model.images.isNotEmpty ? model.images.first.md : 'assets/svg/online_hvit_o.svg',
                  //   fit: BoxFit.cover,
                  // ),
                ),
                // ... other widget components, use properties from EventModel
                Positioned(
                  right: 15,
                  bottom: 40,
                  child: Text(
                    formatDate(), // Use formatted date
                    style: OnlineTheme.textStyle(
                      size: 15,
                      weight: 7,
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 222 + 10,
                  left: 15,
                  child: Text(
                    truncateWithEllipsis(
                        model.title, 35), // Use title from EventModel
                    style: OnlineTheme.textStyle(
                      color: OnlineTheme.gray11,
                      weight: 7,
                    ),
                  ),
                ),
                Positioned(
                  left: 15,
                  bottom: 15,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    decoration: BoxDecoration(
                      color: model.eventType == 3
                          ? OnlineTheme.blue2
                          : (model.eventType == 2
                              ? OnlineTheme.pink2
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      getEventTypeDisplay(),
                      style: OnlineTheme.textStyle(weight: 5, size: 14),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 12,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: ThemedIcon(
                          icon: IconType.people,
                          size: 16,
                          color: OnlineTheme.green1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        model.numberOfSeatsTaken == null &&
                                model.maxCapacity == null
                            ? '∞'
                            : '${model.numberOfSeatsTaken ?? 0}/${model.maxCapacity ?? 0}',
                        style: OnlineTheme.textStyle(size: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
