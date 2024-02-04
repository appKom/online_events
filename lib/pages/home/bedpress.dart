import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/components/animated_button.dart';
import '/components/skeleton_loader.dart';
import '/core/models/event_model.dart';
import '/pages/event/event_page.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';

class Bedpress extends StatelessWidget {
  const Bedpress({
    super.key,
    required this.models,
  });

  final Set<EventModel> models;

  static Widget skeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Bedriftpresentasjoner og Kurs',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
        ),
        SizedBox(
          height: 236,
          child: ListView.builder(
            itemCount: 2,
            itemBuilder: (c, i) {
              return Padding(
                padding: const EdgeInsets.only(right: 24),
                child: SkeletonLoader(
                  borderRadius: BorderRadius.circular(12),
                  width: 222,
                ),
              );
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final futureEvents = models.where((event) {
      final eventDate = DateTime.parse(event.endDate);
      return eventDate.isAfter(DateTime.now());
    }).toList();

    final filteredModels = futureEvents.where((model) => model.eventType == 2 || model.eventType == 3).toList();

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
          height: 255,
          child: ListView.builder(
            itemCount: filteredModels.length,
            itemBuilder: (c, i) {
              return Padding(
                padding: EdgeInsets.only(right: i < filteredModels.length - 1 ? 24 : 0),
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
    return (text.length <= maxLength) ? text : '${text.substring(0, maxLength)}...';
  }

  void showInfo() {
    PageNavigator.navigateTo(EventPageDisplay(
      model: model,
    ));
  }

  String getEventTypeDisplay() {
    // Check if the eventTypeDisplay is 'Bedriftspresentasjon'
    return model.eventTypeDisplay == 'Bedriftspresentasjon' ? 'Bedpress' : model.eventTypeDisplay;
  }

  BoxDecoration? badgeDecoration(int eventType) {
    // Kurs
    if (eventType == 3) {
      return BoxDecoration(
        color: OnlineTheme.green.darken(20).withOpacity(0.4),
        borderRadius: OnlineTheme.buttonRadius,
        border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.green, width: 2)),
      );
    }

    // Bedpress
    if (eventType == 2) {
      return BoxDecoration(
        color: OnlineTheme.red.darken(20).withOpacity(0.4),
        borderRadius: OnlineTheme.buttonRadius,
        border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.red, width: 2)),
      );
    }

    return null;
  }

  Color getColor(int eventType) {
    if (eventType == 3) return OnlineTheme.green;
    if (eventType == 2) return OnlineTheme.red;
    return OnlineTheme.white;
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
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 125,
                  child: model.images.isNotEmpty
                      ? Image.network(
                          model.images.first.md,
                          fit: BoxFit.cover,
                        )
                      : SvgPicture.asset(
                          'assets/svg/online_hvit_o.svg', // Replace with your default image asset path
                          fit: BoxFit.cover,
                        ),
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
                  top: 125 + 10,
                  left: 15,
                  child: Text(
                    truncateWithEllipsis(model.title, 35), // Use title from EventModel
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
                    padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                    decoration: badgeDecoration(model.eventType),
                    child: Text(
                      getEventTypeDisplay(),
                      style: OnlineTheme.textStyle(weight: 5, size: 14, color: getColor(model.eventType)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 12,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 20,
                        color: OnlineTheme.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        model.numberOfSeatsTaken == null && model.maxCapacity == null
                            ? '∞'
                            : '${model.numberOfSeatsTaken ?? 0}/${model.maxCapacity ?? 0}',
                        style: OnlineTheme.textStyle(weight: 5, size: 14),
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
