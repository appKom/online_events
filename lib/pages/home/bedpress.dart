import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/pages/event/event_page.dart';
import '/services/page_navigator.dart';
import '/pages/home/event_card.dart';
import '/theme/themed_icon.dart';

import '../../theme/theme.dart';

class Bedpress extends StatelessWidget {
  const Bedpress({
    super.key,
    required this.models,
  });

  final List<EventModel> models;

  @override
  Widget build(BuildContext context) {
    final futureEvents = models.where((event) {
      final eventDate = DateTime.parse(event.endDate);
      return eventDate.isAfter(DateTime.now());
    }).toList();

    final filteredModels = futureEvents
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
            itemCount: filteredModels.length,
            itemBuilder: (c, i) {
              return Padding(
                padding: EdgeInsets.only(
                    right: i < filteredModels.length - 1 ? 24 : 0),
                child: BedpressCard(
                  model: filteredModels[i],
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

class BedpressCard extends StatelessWidget {
  const BedpressCard({
    super.key,
    required this.model,
  });

  final EventModel model;

  static const monthsNorwegian = [
    'Januar',
    'Februar',
    'Mars',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String formatDate() {
    final date = DateTime.parse(model.startDate);
    final day = date.day.toString().padLeft(2, '0');
    final month = monthsNorwegian[date.month - 1]; // Norwegian month
    return "$day. $month";
  }

  String truncateWithEllipsis(String text, int maxLength) {
    return (text.length <= maxLength)
        ? text
        : '${text.substring(0, maxLength)}...';
  }

  void showInfo() {
    PageNavigator.navigateTo(EventPageDisplay(
      model: model,
    ));
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
                      gradient: model.eventType == 3
                          ? OnlineTheme.blueGradient
                          : (model.eventType == 2
                              ? OnlineTheme.redGradient
                              : null),
                      borderRadius: BorderRadius.circular(8),
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
