import 'package:flutter/material.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/pages/home/event_card.dart';

import '../../components/online_scaffold.dart';
import '../../theme/theme.dart';
import '/main.dart';

class EventsPage extends ScrollablePage {
  const EventsPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);
    final now = DateTime.now();

    // Filter eventModels to include only future events
    final futureEvents = eventModels.where((event) {
      final eventDate = DateTime.parse(event.endDate);
      return eventDate.isAfter(now);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: OnlineHeader.height(context) + 40),
        Text(
          'Kommende Arrangementer',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          height: 111.0 * futureEvents.length,
          child: ListView.builder(
            itemCount: futureEvents.length,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (c, i) => EventCard(
              model: futureEvents[i],
            ),
          ),
        ),
        SizedBox(height: Navbar.height(context)),
      ],
    );
  }
}
