import 'package:flutter/material.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:intl/intl.dart';

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
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ThemedIcon(icon: IconType.dateTime, size: 20),
                SizedBox(width: 8),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    EventDateFormatter.formatEventDates(model.startDate, model.endDate),
                    style: const TextStyle(
                      color: OnlineTheme.white,
                      fontSize: 14,
                      fontFamily: OnlineTheme.font,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ThemedIcon(icon: IconType.location, size: 20),
                const SizedBox(width: 8),
                Text(
                  model.location,
                  style: OnlineTheme.textStyle(height: 1, size: 14),
                ),
                const SizedBox(width: 16),
                // AnimatedButton(
                //   onTap: () {
                //     // TODO: MazeMap link
                //   },
                //   childBuilder: (context, hover, pointerDown) {
                //     return Container(
                //       height: 20,
                //       padding: const EdgeInsets.symmetric(horizontal: 8),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(2),
                //         color: OnlineTheme.blue1,
                //       ),
                //       child: Row(
                //         children: [
                //           Image.asset(
                //             'assets/images/maze_map.png',
                //             width: 18,
                //             height: 17.368,
                //           ),
                //           const SizedBox(width: 5),
                //           Text(
                //             'MazeMap',
                //             style: OnlineTheme.textStyle(
                //               color: OnlineTheme.white,
                //               size: 12,
                //               weight: 6,
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
