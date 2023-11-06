import 'package:flutter/material.dart';
import 'package:online_events/main.dart';

import '/pages/home/profile_button.dart';
import '/online_scaffold.dart';
import 'event_card.dart';
import '/theme.dart';

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
                style: OnlineTheme.UpcommingEventstext,
              ),
            ),
            ListView.builder(
              itemCount: 1,
              itemBuilder: (c, i) => EventCard(
                model: testModels[0],
              ),
            ),
            const Center(
              child: Text(
                'Tidligere Arrangementer',
                style: OnlineTheme.UpcommingEventstext,
              ),
            ),
            ListView.builder(
              itemCount: 6,
              itemBuilder: (c, i) => EventCard(
                model: testModels[0],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
