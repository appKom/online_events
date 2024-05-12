import 'package:flutter/material.dart';

import '/components/skeleton_loader.dart';
import '/theme/theme.dart';
import 'calendar_card.dart';

Widget skeletonLoader(BuildContext context) {
  final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

  final time = DateTime.now();
  String monthName = norwegianMonths[time.month - 1];
  int year = time.year;

  return Padding(
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$monthName $year', style: OnlineTheme.textStyle(size: 16)),
            ],
          ),
        ),
        // const SizedBox(height: 30),
        CalendarCardState.buildCustomWeekdayHeaders(),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(5, (day) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (week) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SkeletonLoader(
                      height: 44,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                );
              }),
            );
          }),
        )
      ],
    ),
  );
}
