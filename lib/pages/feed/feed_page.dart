import 'package:flutter/material.dart';
import 'package:online/components/online_scaffold.dart';
import 'package:online/pages/feed/no_feed_events.dart';
import '/components/animated_button.dart';
import '/core/client/client.dart';
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
    //If attended events has not yet been fetched, it wil fetch the first page, else it will display the events without loading
    if (allAttendedEvents.isEmpty) {
      fetchAttendeeInfo(
        page: 1,
        shouldUpdatePageCount: false,
      );
      isLoading = true;
    } else {
      isLoading = false;
    }
  }

  Future<void> fetchAttendeeInfo({
    required int page,
    required bool shouldUpdatePageCount,
  }) async {
    if (isFetching || !hasMoreEventsToFetch) return;
    isFetching = true;
    final user = Client.userCache.value;

    if (user == null) return;
    List<int> attendedEventIds = [];

    await Client.getAttendanceEvents(userId: user.id, page: page);

    final events = Client.eventAttendanceCache.value;
    if (events.isNotEmpty) {
      for (final event in events) {
        attendedEventIds.add(event.id);
      }
    }

    if (attendedEventIds.isNotEmpty) {
      Map<String, EventModel>? fetchedEvents = await Client.getEventsWithIds(eventIds: attendedEventIds);
      if (fetchedEvents != null) {
        allAttendedEvents = fetchedEvents.values.toList();

        Set<int> fetchedEventIds = {};

        for (var entry in fetchedEvents.entries) {
          fetchedEventIds.add(entry.value.id);
        }

        // Set<int> fetchedEventIds = fetchedEvents.map((key, value) => value.id).values.toSet();
        attendedEventIds.removeWhere((id) => fetchedEventIds.contains(id));
      }
    } else {
      if (mounted) {
        setState(() {
          hasMoreEventsToFetch = false;
        });
      }
    }
    if (page == 1 && attendedEventIds.isEmpty && allAttendedEvents.isEmpty) {
      if (mounted) {
        setState(() {
          hasAttendedAnyEvent = false;
        });
      }
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    Client.eventAttendanceCache.value.clear();
    isFetching = false;
    if (shouldUpdatePageCount) {
      whatAttendencePageShouldBeFetched += 1;
    }
  }

  Future<void> fetchReload({
    required int pageCount,
    required bool shouldUpdatePageCount,
  }) async {
    await fetchAttendeeInfo(page: pageCount, shouldUpdatePageCount: shouldUpdatePageCount);

    setState(() {
      reloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final List<EventModel> futureEvents = [];
    final List<EventModel> pastEvents = [];

    for (MapEntry<String, EventModel> entry in Client.eventsCache.value.entries) {
      final event = entry.value;
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

    if (isLoading || allAttendedEvents.isEmpty) {
      return skeletonLoader(context);
    }

    return Padding(
      padding: padding + EdgeInsets.symmetric(vertical: 64),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          double triggerFetchMoreThreshold = scrollInfo.metrics.maxScrollExtent * 0.95;
          if (scrollInfo.metrics.pixels > triggerFetchMoreThreshold && hasMoreEventsToFetch) {
            fetchAttendeeInfo(page: whatAttendencePageShouldBeFetched, shouldUpdatePageCount: true);
          }
          return true;
        },
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
                const Spacer(),
                AnimatedButton(onTap: () {
                  fetchReload(pageCount: 1, shouldUpdatePageCount: false);
                  if (mounted) setState(() => reloading = true);
                }, childBuilder: (context, hover, pointerDown) {
                  return Icon(
                    Icons.refresh_outlined,
                    color: OnlineTheme.current.fg,
                    size: 32,
                  );
                }),
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

class FeedPageDisplay extends ScrollablePage {
  const FeedPageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return const FeedPage();
  }
}
