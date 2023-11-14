import 'package:flutter/material.dart';
import 'package:online_events/pages/event/cards/event_card.dart';
import 'package:online_events/theme/themed_icon.dart';

import '/components/animated_button.dart';
import '/theme/theme.dart';

class EventAttendanceCard extends StatelessWidget {
  const EventAttendanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return OnlineCard(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ThemedIcon(icon: IconType.dateTime, size: 20),
                SizedBox(width: 8),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    'Tirsdag 31. okt., 16:15 - 20:00',
                    style: TextStyle(
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
                const Text(
                  'R1, Realfagbygget',
                  style: TextStyle(
                    color: OnlineTheme.white,
                    fontSize: 14,
                    fontFamily: OnlineTheme.font,
                  ),
                ),
                const SizedBox(width: 16),
                AnimatedButton(
                  onTap: () {
                    // TODO: MazeMap link
                  },
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: OnlineTheme.blue1,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/maze_map.png',
                            width: 18,
                            height: 17.368,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'MazeMap',
                            style: OnlineTheme.textStyle(
                              color: OnlineTheme.white,
                              size: 12,
                              weight: 6,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
