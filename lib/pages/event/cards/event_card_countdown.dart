import 'package:flutter/material.dart';

import '/theme/theme.dart';

/// Nedtelling til påmeldings-start.
class EventCardCountdown extends StatelessWidget {
  const EventCardCountdown({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          numberColumn("12", "Dager"),
          numberColumn("4", "Timer"),
          numberColumn("8", "Minutter"),
          numberColumn("6", "Sekunder"),
        ],
      ),
    );
  }

  Widget numberColumn(String number, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          number,
          style: OnlineTheme.textStyle(
            height: 1,
            weight: 7,
            size: 20,
          ),
        ),
        Text(
          label,
          style: OnlineTheme.textStyle(
            height: 1,
            size: 14,
          ),
        ),
      ],
    );
  }
}
