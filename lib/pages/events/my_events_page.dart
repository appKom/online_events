import 'package:flutter/material.dart';
import 'package:online/pages/events/calender.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/components/skeleton_loader.dart';
import '/core/client/client.dart';
import '/core/models/event_model.dart';
import '/pages/home/event_card.dart';
import '/services/authenticator.dart';
import '/theme/theme.dart';

// List<AttendedEvents> attendedEvents = [];
List<EventModel> pastEventModels = [];

// TODO; We have these months multiple places, should be moved to a shared file
final List<String> norwegianMonths = [
  'Januar',
  'Februar',
  'Mars',
  'April',
  'Mai',
  'Juni',
  'Juli',
  'August',
  'September',
  'Oktober',
  'November',
  'Desember'
];

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  static Widget skeletonLoader(BuildContext context) {
    final padding =
        MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    final time = DateTime.now();
    String monthName = norwegianMonths[time.month - 1];
    int year = time.year;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$monthName $year',
                    style: OnlineTheme.textStyle(
                        size: 16, color: OnlineTheme.white)),
              ],
            ),
          ),
          // const SizedBox(height: 30),
          MyEventsPageState.buildCustomWeekdayHeaders(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(5, (day) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (week) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: SkeletonLoader(
                        height: 44,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                }),
              );
            }),
          )
        ],
      ),
    );
  }

  @override
  MyEventsPageState createState() => MyEventsPageState();
}

class MyEventsPageState extends State<MyEventsPage> {
  DateTime _focusedDay = DateTime.now();
  bool _isLoading = true;

  static final ValueNotifier<int> eventPageOffset = ValueNotifier(0);
  static final ValueNotifier<int> attendancePageOffset = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    if (Authenticator.isLoggedIn()) {
      // TODO: This logic is convoluted and can cause memory leaks if exited at unexpected times
      fetchMoreEvents()
          .then((_) {
            fetchAttendeeInfo();
          })
          .catchError((error) {})
          .whenComplete(() {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchMoreEvents() async {
    final offset = eventPageOffset.value;
    final moreEventsPage1 =
        await Client.getEvents(pages: [offset + 1, offset + 2]);

    final events = Client.eventsCache.value;

    if (mounted) {
      setState(() {
        if (moreEventsPage1 != null) {
          for (var event in moreEventsPage1) {
            if (!events.any((existingEvent) => existingEvent.id == event.id)) {
              events.add(event);
            }
          }
        }
        eventPageOffset.value += 2;
      });
    }
  }

  Future<void> fetchAttendeeInfo() async {
    final user = Client.userCache.value;

    if (user == null) return;

    final offset = attendancePageOffset.value;

    await Client.getAttendanceEvents(
        userId: user.id, pageCount: 2, pageOffset: offset);

    attendancePageOffset.value += 2;

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  static const List<String> _norwegianWeekDays = [
    'Man',
    'Tir',
    'Ons',
    'Tor',
    'Fre',
    'Lør',
    'Søn'
  ];

  static Widget customDaysOfWeekBuilder(BuildContext context, int i) {
    return Center(
      child: Text(
        _norwegianWeekDays[i % 7],
        style: OnlineTheme.textStyle(),
      ),
    );
  }

  // Custom Header Widget
  Widget _customHeaderWidget({
    required DateTime focusedDay,
    required VoidCallback onLeftArrowTap,
    required VoidCallback onRightArrowTap,
  }) {
    String monthName = norwegianMonths[focusedDay.month - 1];
    int year = focusedDay.year;

    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: onLeftArrowTap,
          ),
          Text('$monthName $year',
              style: OnlineTheme.textStyle(size: 16, color: OnlineTheme.white)),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  static Widget buildCustomWeekdayHeaders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _norwegianWeekDays
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: OnlineTheme.textStyle(), // Your desired style
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MyEventsPage.skeletonLoader(context);
    }

    final padding =
        MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    final now = DateTime.now();

    final eventAttendances = Client.eventAttendanceCache.value;

    final upcomingEvents = Client.eventsCache.value
        .where((model) => eventAttendances.any((event) => event.id == model.id))
        .where((model) {
      final eventDate = DateTime.parse(model.startDate);
      return eventDate.isAfter(now);
    }).toList();

    print(upcomingEvents.length);

    final pastEvents = Client.eventsCache.value
        .where((model) => eventAttendances.any((event) => event.id == model.id))
        .where((model) {
      final eventDate = DateTime.parse(model.startDate);
      return eventDate.isBefore(now);
    }).toList();

    List<EventModel> getEventsForDay(DateTime day) {
      List<EventModel> selectedEvents = [];

      bool isEventOnDay(EventModel event, DateTime day) {
        final startDate = DateTime.parse(event.startDate).toLocal();
        final endDate = DateTime.parse(event.endDate).toLocal();
        final comparisonDayStart = DateTime(day.year, day.month, day.day);
        final comparisonDayEnd =
            DateTime(day.year, day.month, day.day, 23, 59, 59);

        return (startDate.isAtSameMomentAs(comparisonDayStart) ||
                startDate.isBefore(comparisonDayEnd)) &&
            (endDate.isAtSameMomentAs(comparisonDayStart) ||
                endDate.isAfter(comparisonDayStart));
      }

      selectedEvents
          .addAll(upcomingEvents.where((event) => isEventOnDay(event, day)));
      selectedEvents
          .addAll(pastEvents.where((event) => isEventOnDay(event, day)));

      return selectedEvents;
    }

    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            _customHeaderWidget(
              focusedDay: _focusedDay,
              onLeftArrowTap: () {
                setState(() {
                  _focusedDay = DateTime(
                      _focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                });
              },
              onRightArrowTap: () {
                setState(() {
                  _focusedDay = DateTime(
                      _focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
                });
              },
            ),
            buildCustomWeekdayHeaders(),
            CalenderPage(
                upcomingEvents: upcomingEvents, pastEvents: pastEvents),
            const SizedBox(height: 24 + 24),
            Text('Mine Arrangementer', style: OnlineTheme.header()),
            _buildEventList(upcomingEvents),
            const SizedBox(height: 24 + 24),
            Text('Tidligere Arrangementer', style: OnlineTheme.header()),
            _buildEventList(pastEvents),
            const SizedBox(height: 24),
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
                        style: OnlineTheme.textStyle(weight: 5),
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(List<EventModel> events) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 100.0 * events.length,
      child: ListView.builder(
        itemCount: events.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => EventCard(
          model: events[index],
        ),
      ),
    );
  }
}

class MyEventsPageDisplay extends ScrollablePage {
  const MyEventsPageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return const MyEventsPage();
  }
}
