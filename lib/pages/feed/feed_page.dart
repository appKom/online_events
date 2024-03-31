import 'package:flutter/material.dart';
import 'package:online/components/online_scaffold.dart';
import 'package:online/pages/feed/no_feed_events.dart';
import '../../core/client/client.dart';
import '../../core/models/event_model.dart';
import '../../theme/theme.dart';
import '../home/event_card.dart';
import '../../main.dart';
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

  @override
  void initState() {
    super.initState();
    //If attended events has not yet been fetched, it wil fetch the first page, else it will display the events without loading
    if (allAttendedEvents.isEmpty) {
      fetchAttendeeInfo(
        pageCount: 1,
        shouldUpdatePageCount: false,
      );
      isLoading = true;
    } else {
      isLoading = false;
    }
  }

  Future<void> fetchAttendeeInfo({
    required int pageCount,
    required bool shouldUpdatePageCount,
  }) async {
    if (isFetching) return;
    isFetching = true;
    if (!hasMoreEventsToFetch) return;
    final user = Client.userCache.value;

    if (user == null) return;
    List<int> attendedEventIds = [];

    await Client.getAttendanceEvents(userId: user.id, pageCount: pageCount);

    final events = Client.eventAttendanceCache.value;
    if (events.isNotEmpty) {
      for (final event in events) {
        attendedEventIds.add(event.id);
      }
    }
    print('attended event ids: $attendedEventIds');
    if (attendedEventIds.isNotEmpty) {
      Set<EventModel>? fetchedEvents =
          await Client.getEventsWithIds(eventIds: attendedEventIds);
      if (fetchedEvents != null) {
        allAttendedEvents = fetchedEvents.toList();
        Set<int> fetchedEventIds = fetchedEvents.map((e) => e.id).toSet();
        attendedEventIds.removeWhere((id) => fetchedEventIds.contains(id));
      }
    } else {
      if (mounted) {
        setState(() {
          hasMoreEventsToFetch = false;
        });
      }
    }
    if (pageCount == 1 &&
        attendedEventIds.isEmpty &&
        allAttendedEvents.isEmpty) {
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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcomingEvents = Client.eventsIdsCache.value.where((event) {
      final today = DateTime.now();
      final eventDate = DateTime.parse(event.endDate);
      return eventDate.isAfter(today);
    }).toList();

    final pastEvents = Client.eventsIdsCache.value.where((event) {
      final endDate = DateTime.parse(event.endDate);
      return endDate.isBefore(now);
    }).toList()
      ..sort((a, b) {
        final aEndDate = DateTime.parse(a.endDate);
        final bEndDate = DateTime.parse(b.endDate);
        return bEndDate.compareTo(aEndDate);
      });

    if (hasAttendedAnyEvent == false) {
      return const NoFeedEvents();
    }

    if (isLoading || allAttendedEvents.isEmpty) {
      return skeletonLoader(context);
    }

    final padding =
        MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;
    return Padding(
      padding: padding,
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          double triggerFetchMoreThreshold =
              scrollInfo.metrics.maxScrollExtent * 0.95;
          if (scrollInfo.metrics.pixels > triggerFetchMoreThreshold &&
              hasMoreEventsToFetch) {
            fetchAttendeeInfo(
                pageCount: whatAttendencePageShouldBeFetched,
                shouldUpdatePageCount: true);
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              CalendarCard(
                  upcomingEvents: upcomingEvents, pastEvents: pastEvents),
              const SizedBox(height: 24 + 24),
              Text('Mine Arrangementer', style: OnlineTheme.header()),
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
      ),
    );
  }
}

class FeedPageDisplay extends StaticPage {
  const FeedPageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return const FeedPage();
  }
}
