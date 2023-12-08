import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/pages/home/event_card_loggedin.dart';
import 'package:online_events/pages/login/login_page.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import 'package:online_events/services/page_navigator.dart';

import '../home/event_card.dart';
import '../../theme/theme.dart';
import '/main.dart';

List<int> registeredEvents = [];

class MyEventsPageLoggedIn extends StatefulWidget {
  const MyEventsPageLoggedIn({Key? key}) : super(key: key);

  @override
  _MyEventsPageLoggedInState createState() => _MyEventsPageLoggedInState();
}

class _MyEventsPageLoggedInState extends State<MyEventsPageLoggedIn> {
  @override
  void initState() {
    super.initState();
    _populateRegisteredEvents();
    print(registeredEvents);
  }

  void _populateRegisteredEvents() {
    registeredEvents = attendeeInfoModels
        .where((attendeeInfo) => attendeeInfo.isAttendee)
        .map((attendeeInfo) => attendeeInfo.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    final style = OnlineTheme.textStyle(size: 20, weight: 7);
    final now = DateTime.now();

    // Filter for upcoming registered events
    final upcomingEvents = eventModels
        .where((model) => registeredEvents.contains(model.id))
        .where((model) {
          final eventDate = DateTime.parse(model.startDate);
          return eventDate.isAfter(now);
        }).toList();

    // Filter for past registered events
    final pastEvents = eventModels
        .where((model) => registeredEvents.contains(model.id))
        .where((model) {
          final eventDate = DateTime.parse(model.startDate);
          return eventDate.isBefore(now);
        }).toList();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: OnlineHeader.height(context) + 40),
            Center(
              child: Text('Mine Arrangementer', style: style),
            ),
            _buildEventList(upcomingEvents),
            const SizedBox(height: 24),
            Center(
              child: Text('Tidligere Arrangementer', style: style),
            ),
            _buildEventList(pastEvents),
            SizedBox(height: Navbar.height(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(List<EventModel> events) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 111.0 * events.length,
      child: ListView.builder(
        itemCount: events.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => EventCardLoggedIn(
          model: events[index],
          attendeeInfoModel: attendeeInfoModels[index], // Ensure this list aligns with events
          attendeeInfoModels: attendeeInfoModels,
        ),
      ),
    );
  }
}