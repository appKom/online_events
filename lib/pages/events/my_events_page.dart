import 'package:flutter/material.dart';

import '../home/event_card.dart';
import '../../theme/theme.dart';
import '/main.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final style = OnlineTheme.textStyle(weight: 5, size: 12);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            'Mine Arrangementer',
            style: style,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 111 * 1,
          child: ListView.builder(
            itemCount: 6,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) => EventCard(
              model: testModels[0],
            ),
          ),
        ),
        Center(
          child: Text(
            'Tidligere Arrangementer',
            style: style,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: 111 * 6,
          child: ListView.builder(
            itemCount: 6,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) => EventCard(
              model: testModels[0],
            ),
          ),
        ),
      ],
    );
  }
}
