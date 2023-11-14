import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class EventCardCountdown extends StatelessWidget {
  const EventCardCountdown({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNumberColumn("12", "Dager"),
            buildNumberColumn("4", "Timer"),
            buildNumberColumn("8", "Minutter"),
            buildNumberColumn("6", "Sekunder"),
          ],
        ),
      ),
    );
  }

  Widget buildNumberColumn(String number, String label) {
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
