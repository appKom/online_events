import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/separator.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/pages/event/event_page.dart';
import '../../services/page_navigator.dart';
import '../../theme/theme.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.model});

  final EventModel model;

  static const months = [
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

  String dateToString() {
    final date = DateTime.parse(model.startDate);

    final day = date.day;
    final dayString = day.toString().padLeft(2, '0');

    final month = date.month - 1; // Months go from 1-12 but we need an index of 0-11
    final monthString = months[month];

    // TODO: If an event spans multiple days, show 01.-05. January
    // TODO: If start and end month is different, shorten to 28. Jan - 03. Feb

    return '$dayString. $monthString';
  }

  String shortenName() {
    final name = model.title;
    return name.replaceAll('Bedriftspresentasjon', 'Bedpress');
  }

  String registeredToString() {
    return '${model.numberOfSeatsTaken}/${model.maxCapacity}';
  }

  void showInfo() {
    PageNavigator.navigateTo(EventPage(model: model));
  }

  String peopleToString() {
    if (model.maxCapacity == null) return 'Ubegrenset';

    return '${model.numberOfSeatsTaken}/${model.maxCapacity}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 111,
      child: Stack(
        children: [
          AnimatedButton(
            behavior: HitTestBehavior.opaque,
            onTap: showInfo,
            childBuilder: (context, hover, pointerDown) {
              return Stack(
                children: [
                  // Event Icon
                  Positioned(
                    left: 0,
                    top: 10,
                    width: 84,
                    height: 84,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        model.images.first.md,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Headers
                  Positioned(
                    left: 100,
                    top: 10,
                    right: 0,
                    height: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Name
                        SizedBox(
                          height: 24,
                          child: Text(
                            shortenName(),
                            style: OnlineTheme.textStyle(
                              color: OnlineTheme.gray11,
                              weight: 7,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subHeader(
                          Icons.calendar_month_outlined,
                          dateToString(),
                        ),
                        subHeader(
                          Icons.people_outline,
                          peopleToString(),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 15,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'INFO',
                          style: OnlineTheme.textStyle(
                            color: OnlineTheme.gray9,
                            weight: 5,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.navigate_next,
                            color: OnlineTheme.gray9,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Bottom Separator
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Separator(),
          ),
        ],
      ),
    );
  }

  Widget subHeader(IconData icon, String text) {
    return SizedBox(
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              icon,
              color: OnlineTheme.gray9,
              size: 14,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: OnlineTheme.textStyle(
              size: 14,
              weight: 5,
              color: OnlineTheme.gray9,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
