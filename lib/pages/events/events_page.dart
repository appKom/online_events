import 'package:flutter/material.dart';

import '/components/navbar.dart';
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
  bool hasMoreEvents = true;

  Future<void> fetchMoreEvents() async {
    if (!hasMoreEvents) return;

    final moreEventsPage =
        await Client.getEvents(pages: [currentPage + 1, currentPage + 2]);
    final events = Client.eventsCache.value.toList();
    final now = DateTime.now();

    if (mounted) {
      setState(() {
        if (moreEventsPage != null) {
          for (var event in moreEventsPage) {
            final eventStartDate = DateTime.parse(event.startDate);
            if (eventStartDate.isBefore(now)) {
              hasMoreEvents = false;
              break;
            }
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
    final padding =
        MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;
    final now = DateTime.now();

    final futureEvents = Client.eventsCache.value.where((event) {
      final eventDate = DateTime.parse(event.endDate);
      return eventDate.isAfter(now);
    }).toList();

    return Padding(
      padding: EdgeInsets.only(
          left: padding.left, right: padding.right, top: padding.top),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchMoreEvents();
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Kommende Arrangementer',
                style: OnlineTheme.header(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 100.0 * futureEvents.length,
                child: ListView.builder(
                  itemCount: futureEvents.length,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) => EventCard(
                    model: futureEvents[i],
                  ),
                ),
              ),
              if (hasMoreEvents)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              SizedBox(height: Navbar.height(context) + 10),
            ],
          ),
        ),
      ),
    );
  }
}
