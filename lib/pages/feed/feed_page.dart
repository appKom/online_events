import 'package:flutter/material.dart';
import 'package:online/components/online_scaffold.dart';
import 'package:online/core/client/calendar_client.dart';
import 'package:online/pages/events/not_logged_in_page.dart';
import 'package:online/pages/feed/no_feed_events.dart';
import 'package:online/services/authenticator.dart';
import '/components/animated_button.dart';
import '/core/models/event_model.dart';
import '/theme/theme.dart';
import '../home/event_card.dart';
import '/main.dart';
import 'calendar_card.dart';
import 'calendar_skeleton.dart';

// Don't remove
int whatAttendencePageShouldBeFetched = 2;

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  bool isLoading = true;

  List<EventModel> upcomingEvents = [];
  List<EventModel> pastEvents = [];

  bool isFetching = false;
  bool hasMoreEventsToFetch = true;
  bool hasAttendedAnyEvent = true;
  bool reloading = false;

  @override
  void initState() {
    super.initState();
    //TODO
  }

  @override
  Widget build(BuildContext context) {
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

    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    if (hasAttendedAnyEvent == false) {
      return Padding(
        padding: padding + EdgeInsets.symmetric(vertical: 64),
        child: const NoFeedEvents(),
      );
    }

    if (isLoading || CalendarClient.calendarEventCache.value == null) {
      return skeletonLoader(context);
    }

    return Padding(
      padding: padding + EdgeInsets.symmetric(vertical: 64),
      child: NotificationListener<ScrollNotification>(
        // onNotification: (ScrollNotification scrollInfo) {
        //   double triggerFetchMoreThreshold = scrollInfo.metrics.maxScrollExtent * 0.95;
        //   if (scrollInfo.metrics.pixels > triggerFetchMoreThreshold && hasMoreEventsToFetch) {
        //     fetchAttendeeInfo(page: whatAttendencePageShouldBeFetched, shouldUpdatePageCount: true);
        //   }
        //   return true;
        // },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            if (reloading) const CircularProgressIndicator(),
            if (reloading) const SizedBox(height: 24),
            CalendarCard(upcomingEvents: upcomingEvents, pastEvents: pastEvents),
            const SizedBox(height: 24 + 24),
            Row(
              children: [
                Text('Mine Arrangementer', style: OnlineTheme.header()),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              // margin: const EdgeInsets.symmetric(vertical: 10),
              height: 100.0 * upcomingEvents.length,
              child: ListView.builder(
                itemCount: upcomingEvents.length,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => EventCard(
                  model: upcomingEvents[index],
                ),
              ),
            ),
            const SizedBox(height: 24 + 24),
            Text('Tidligere Arrangementer', style: OnlineTheme.header()),
            const SizedBox(height: 24),
            SizedBox(
              // margin: const EdgeInsets.symmetric(vertical: 10),
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
            if (pastEvents.isNotEmpty && hasMoreEventsToFetch)
              Column(
                children: List.generate(2, (_) => EventCard.skeleton()),
              ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
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
