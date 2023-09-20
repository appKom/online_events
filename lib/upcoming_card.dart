import 'package:flutter/material.dart';
import '/models/list_event.dart';
import '/theme.dart';

class UpcomingCard extends StatelessWidget {
  const UpcomingCard({super.key, required this.model});

  final ListEventModel model;

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
    final date = model.date;

    final day = date.day;
    final dayString = day.toString().padLeft(2, '0');

    final month = date.month - 1; // Months go from 1-12 but we need an index of 0-11
    final monthString = months[month];

    return '$dayString. $monthString';
  }

  String shortenName() {
    final name = model.name;
    return name.replaceAll('Bedriftspresentasjon', 'Bedpress');
  }

  String registeredToString() {
    return '${model.registered}/${model.capacity}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 111,
      child: Stack(
        children: [
          // Event Icon
          Positioned(
            left: 0,
            top: 10,
            width: 84,
            height: 84,
            child: Container(
              decoration: const BoxDecoration(
                color: OnlineTheme.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
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
                    style: OnlineTheme.eventListHeader,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Date
                subHeader(Icons.calendar_month_outlined, dateToString()),
                // Registered and Capacity
                subHeader(Icons.people_outline, '${model.registered}/${model.capacity}'),
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
                  style: OnlineTheme.eventListSubHeader.copyWith(fontWeight: FontWeight.w500),
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
          // Bottom Separator
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 1,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF000212),
                    Color(0xFF2E3440),
                    Color(0xFF000212),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget subHeader(IconData icon, String text) {
    return SizedBox(
      height: 18,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              color: OnlineTheme.gray9,
              size: 12,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: OnlineTheme.eventListSubHeader,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
