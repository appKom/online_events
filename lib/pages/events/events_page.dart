import 'package:flutter/material.dart';

import '/components/navbar.dart';
import '/core/client/client.dart';
import '/pages/home/event_card.dart';
import '/theme/theme.dart';

int currentPage = 1;

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  EventsPageState createState() => EventsPageState();
}

class EventsPageState extends State<EventsPage> {
  bool isFetching = false;

  Future<void> fetchMoreEvents() async {
    if (isFetching) return;
    isFetching = true;
    final nextPage = currentPage + 1;
    try {
      final moreEventsPage = await Client.getEvents(pages: [nextPage]);
      final events = Client.eventsCache.value.toList();
      print('fecthing events from page $nextPage');

      if (mounted) {
        setState(() {
          if (moreEventsPage != null) {
            for (var event in moreEventsPage) {
              if (!events.any((existingEvent) => existingEvent.id == event.id)) {
                events.add(event);
              }
            }
            events.sort((a, b) {
              final aEndDate = DateTime.parse(a.endDate);
              final bEndDate = DateTime.parse(b.endDate);
              return aEndDate.compareTo(bEndDate);
            });
            Client.eventsCache.value = Set.from(events);
          }
          currentPage = nextPage;
        });
      }
    } catch (e) {
      print("Failed to fetch events: $e");
    } finally {
      isFetching = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;
    final now = DateTime.now();

    final futureEvents = Client.eventsCache.value.where((event) {
      final today = DateTime.now();
      final eventDate = DateTime.parse(event.endDate);
      return eventDate.isAfter(today);
    }).toList();

    final pastEvents = Client.eventsCache.value.where((event) {
      final endDate = DateTime.parse(event.endDate);
      return endDate.isBefore(now);
    }).toList()
      ..sort((a, b) {
        final aEndDate = DateTime.parse(a.endDate);
        final bEndDate = DateTime.parse(b.endDate);
        return bEndDate.compareTo(aEndDate);
      });

    return Container(
      color: OnlineTheme.background,
      padding: EdgeInsets.only(left: padding.left, right: padding.right, top: padding.top),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          double triggerFetchMoreThreshold = scrollInfo.metrics.maxScrollExtent * 0.95;
          if (scrollInfo.metrics.pixels > triggerFetchMoreThreshold) {
            fetchMoreEvents();
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // const SizedBox(
              //   height: 24,
              // ),
              // CalendarCardEvents(upcomingEvents: futureEvents, pastEvents: pastEvents),
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
              if (pastEvents.isEmpty)
                Column(
                  children: List.generate(2, (_) => EventCard.skeleton()),
                ),
              if (pastEvents.isNotEmpty) const SizedBox(height: 24),
              if (pastEvents.isNotEmpty)
                Text(
                  'Tidligere Arrangementer',
                  style: OnlineTheme.header(),
                ),
              if (pastEvents.isNotEmpty) const SizedBox(height: 24),
              if (pastEvents.isNotEmpty)
                SizedBox(
                  height: 100.0 * pastEvents.length,
                  child: ListView.builder(
                    itemCount: pastEvents.length,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (c, i) => EventCard(
                      model: pastEvents[i],
                    ),
                  ),
                ),
              // if (pastEvents.isNotEmpty) const SizedBox(height: 24),
              if (pastEvents.isNotEmpty)
                Column(
                  children: List.generate(2, (_) => EventCard.skeleton()),
                ),
              SizedBox(height: Navbar.height(context) + 10),
            ],
          ),
        ),
      ),
    );
  }
}
