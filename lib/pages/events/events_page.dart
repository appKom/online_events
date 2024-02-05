import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart';
import '/pages/home/event_card.dart';
import '/theme/theme.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  EventsPageState createState() => EventsPageState();
}

class EventsPageState extends State<EventsPage> {
  int currentPage = 1;

  Future<void> fetchMoreEvents() async {
    final moreEventsPage1 =
        await Client.getEvents(pages: [currentPage + 1, currentPage + 2]);
    final events =
        Client.eventsCache.value.toList(); 

    if (mounted) {
      setState(() {
        if (moreEventsPage1 != null) {
          for (var event in moreEventsPage1) {
            if (!events.any((existingEvent) => existingEvent.id == event.id)) {
              events.add(event);
            }
          }
          events.sort((a, b) {
            final aStartDate = DateTime.parse(a.startDate);
            final bStartDate = DateTime.parse(b.startDate);
            return aStartDate.compareTo(bStartDate);
          });
          Client.eventsCache.value = Set.from(events); 
        }

        currentPage += 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);
    final now = DateTime.now();

    // Filter eventModels to include only future events
    final futureEvents = Client.eventsCache.value.where((event) {
      final eventDate = DateTime.parse(event.endDate);
      return eventDate.isAfter(now);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right, top: padding.top),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24,),
            Text(
              'Kommende Arrangementer',
              style: OnlineTheme.header(),
            ),
            const SizedBox(height: 10),
            SizedBox(
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
            SizedBox(height: Navbar.height(context) + 10),
          ],
        ),
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
