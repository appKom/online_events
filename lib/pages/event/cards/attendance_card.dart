import 'package:flutter/material.dart';

import '/core/models/event_model.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import 'event_card.dart';
import 'event_date_formater.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({super.key, required this.model});

  final EventModel model;

  @override
  Widget build(BuildContext context) {
    return OnlineCard(
      child: Column(
        children: [
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ThemedIcon(icon: IconType.dateTime, size: 20),
                const SizedBox(width: 8),
                Text(
                  EventDateFormatter.formatEventDates(model.startDate, model.endDate),
                  style: OnlineTheme.textStyle(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ThemedIcon(icon: IconType.location, size: 20),
                const SizedBox(width: 8),
                Text(
                  model.location,
                  style: OnlineTheme.textStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
