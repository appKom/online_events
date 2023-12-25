import 'package:flutter/material.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/pages/home/event_card.dart';

import '../../components/animated_button.dart';
import '../../components/online_scaffold.dart';
import '../../core/client/client.dart';
import '../../theme/theme.dart';
import '/main.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  EventsPageState createState() => EventsPageState();
}

class EventsPageState extends State<EventsPage> {
  int currentPage = 1;

  Future<void> fetchMoreEvents() async {
    int nextPage1 = currentPage + 1;
    int nextPage2 = currentPage + 2;

    try {
      var moreEventsPage1 = await Client.getEvents(pages: [nextPage1]);
      var moreEventsPage2 = await Client.getEvents(pages: [nextPage2]);

      if (mounted) {
        setState(() {
          if (moreEventsPage1 != null) {
            for (var event in moreEventsPage1) {
              if (!eventModels
                  .any((existingEvent) => existingEvent.id == event.id)) {
                eventModels.add(event);
              }
            }
          }
          if (moreEventsPage2 != null) {
            for (var event in moreEventsPage2) {
              if (!eventModels
                  .any((existingEvent) => existingEvent.id == event.id)) {
                eventModels.add(event);
              }
            }
          }
          currentPage += 2;
        });
      }
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);
    final now = DateTime.now();

    // Filter eventModels to include only future events
    final futureEvents = eventModels.where((event) {
      final eventDate = DateTime.parse(event.endDate);
      return eventDate.isAfter(now);
    }).toList();

    return SingleChildScrollView(
      child: Column(
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
          const SizedBox(
            height: 5,
          ),
          Center(
            child: AnimatedButton(
              onTap: () {
                fetchMoreEvents();
              },
              childBuilder: (context, hover, pointerDown) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'MER',
                      style: OnlineTheme.textStyle(weight: 4),
                    ),
                    const SizedBox(width: 2),
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.navigate_next,
                        color: OnlineTheme.gray9,
                        size: 15,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: Navbar.height(context)+10),
        ],
      ),
    );
  }
}

class EventsPageDisplay extends StaticPage {
  const EventsPageDisplay({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const EventsPage();
  }
}
