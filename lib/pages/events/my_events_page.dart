import 'package:flutter/material.dart';

import '/pages/home/profile_button.dart';
import '/online_scaffold.dart';
import '../home/event_card.dart';
import '/theme.dart';
import '/main.dart';

class MyEventsPage extends StatelessWidget {
  const MyEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnlineScaffold(
      header: const ProfileButton(),
      content: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const SizedBox(
              height: 20,
            ),
            const Center(
              child: Text(
                'Mine Arrangementer',
                style: OnlineTheme.upcomingEventsText,
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
            const Center(
              child: Text(
                'Tidligere Arrangementer',
                style: OnlineTheme.upcomingEventsText,
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
        ),
      ),
    );
  }
}
