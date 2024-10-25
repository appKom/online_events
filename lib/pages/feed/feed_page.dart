import 'package:flutter/material.dart';
import 'package:online/components/online_scaffold.dart';
import 'package:online/core/client/calendar_client.dart';
import 'package:online/core/client/client.dart';
import 'package:online/pages/events/not_logged_in_page.dart';
import 'package:online/services/authenticator.dart';

import '/core/models/event_model.dart';
import '/theme/theme.dart';
import '../home/event_card.dart';
import 'calendar_card.dart';
import 'calendar_skeleton.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  bool isLoading = true;

  ({List<EventModel> futureEvents, List<EventModel> pastEvents}) futureAndPastEvents() {
    final now = DateTime.now();

    final List<EventModel> futureEvents = [];
    final List<EventModel> pastEvents = [];

    for (EventModel event in CalendarClient.calendarEventCache.value ?? []) {
      final eventDate = DateTime.parse(event.endDate);

      if (eventDate.isAfter(now)) {
        futureEvents.add(event);
      } else if (eventDate.isBefore(now)) {
        pastEvents.add(event);
      }
    }

    pastEvents.sort((a, b) {
      final aEndDate = DateTime.parse(a.endDate);
      final bEndDate = DateTime.parse(b.endDate);
      return bEndDate.compareTo(aEndDate);
    });

    return (futureEvents: futureEvents, pastEvents: pastEvents);
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    return ValueListenableBuilder(
        valueListenable: CalendarClient.calendarEventCache,
        builder: (context, events, child) {
          if (events == null) return skeletonLoader(context);

          var eventsTuple = futureAndPastEvents();
          List<EventModel> futureEvents = eventsTuple.futureEvents;
          List<EventModel> pastEvents = eventsTuple.pastEvents;

          return Padding(
            padding: padding + EdgeInsets.symmetric(vertical: 64),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                double triggerFetchMoreThreshold = scrollInfo.metrics.maxScrollExtent * 0.95;
                if (scrollInfo.metrics.pixels > triggerFetchMoreThreshold) {
                  print('Fetching more events');
                  CalendarClient.getCalendarEventIds(userId: Client.userCache.value!.id, eventIdPage: eventIdPage);
                }
                return true;
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  CalendarCard(upcomingEvents: futureEvents, pastEvents: pastEvents),
                  const SizedBox(height: 24 + 24),
                  Row(
                    children: [
                      Text('Mine Arrangementer', style: OnlineTheme.header()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 100.0 * futureEvents.length,
                    child: ListView.builder(
                      itemCount: futureEvents.length,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => EventCard(
                        model: futureEvents[index],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24 + 24),
                  Text('Tidligere Arrangementer', style: OnlineTheme.header()),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 100.0 * pastEvents.length,
                    child: ListView.builder(
                      itemCount: pastEvents.length,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => EventCard(
                        model: pastEvents[index],
                      ),
                    ),
                  ),
                  if (pastEvents.isNotEmpty)
                    Column(
                      children: List.generate(2, (_) => EventCard.skeleton()),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        });
  }
}

class FeedPageDisplay extends StaticPage {
  const FeedPageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Authenticator.loggedIn,
      builder: (context, loggedIn, child) {
        if (loggedIn) {
          return SingleChildScrollView(padding: EdgeInsets.zero, child: const FeedPage());
        } else {
          return const NotLoggedInPage();
        }
      },
    );
  }
}
