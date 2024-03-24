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

  Future<void> fetchMoreEvents() async {
    final moreEventsPage =
        await Client.getEvents(pages: [currentPage + 1, currentPage + 2]);
    final events = Client.eventsCache.value.toList();
    ;

    if (mounted) {
      setState(() {
        if (moreEventsPage != null) {
          for (var event in moreEventsPage) {
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
      final tommorow = DateTime.now().add(const Duration(days: 1));
      final eventDate = DateTime.parse(event.startDate);
      return eventDate.isAfter(tommorow);
    }).toList();

    final pastEvents = Client.eventsCache.value.where((event) {
      final startDate = DateTime.parse(event.startDate);
      return startDate.isBefore(now);
    }).toList()
      ..sort((a, b) {
        final aStartDate = DateTime.parse(a.startDate);
        final bStartDate = DateTime.parse(b.startDate);
        return bStartDate.compareTo(aStartDate);
      });

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
              const SizedBox(height: 24),
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
