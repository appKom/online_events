import 'package:flutter/material.dart';
import 'package:online/components/online_scaffold.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../components/skeleton_loader.dart';
import '../../core/client/client.dart';
import '../../core/models/event_model.dart';
import '../../services/app_navigator.dart';
import '../../theme/theme.dart';
import '../event/event_page.dart';
import '../home/event_card.dart';

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

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

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
          FeedPageState.buildCustomWeekdayHeaders(),
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
  FeedPageState createState() => FeedPageState();
}

class FeedPageState extends State<FeedPage> {
  static final ValueNotifier<int> attendancePageOffset = ValueNotifier(0);
  bool _isLoading = true;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<int> attendedEventIds = [];
  List<EventModel> allAttendedEvents = [];
  List<EventModel> upcomingEvents = [];
  List<EventModel> pastEvents = [];

  @override
  void initState() {
    super.initState();
    fetchAttendeeInfo();
  }

  Future<void> fetchAttendeeInfo() async {
    final user = Client.userCache.value;

    if (user == null) return;

    final offset = attendancePageOffset.value;
    await Client.getAttendanceEvents(
        userId: user.id, pageCount: 2, pageOffset: offset);
    attendancePageOffset.value += 2;

    for (final event in Client.eventAttendanceCache.value) {
      attendedEventIds.add(event.id);
    }

    Set<EventModel>? fetchedEvents =
        await Client.getEventsWithIds(eventIds: attendedEventIds);
    if (fetchedEvents != null) {
      allAttendedEvents = fetchedEvents.toList();
    }

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

  static Widget buildCustomWeekdayHeaders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _norwegianWeekDays
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: OnlineTheme.textStyle(),
                ),
              ),
            ),
          )
          .toList(),
    );
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

    if (_isLoading) {
      return FeedPage.skeletonLoader(context);
    }

    final padding =
        MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;
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
            TableCalendar(
              headerVisible: false,
              daysOfWeekVisible: false,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              availableCalendarFormats: const {CalendarFormat.month: ''},
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              focusedDay: _focusedDay,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                List<EventModel> eventsForSelectedDay =
                    getEventsForDay(selectedDay);

                if (eventsForSelectedDay.isNotEmpty) {
                  AppNavigator.navigateToPage(
                      EventPageDisplay(model: eventsForSelectedDay.first));
                }
              },
              eventLoader: (day) => getEventsForDay(day),
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, focusedDay) {
                  final eventful = getEventsForDay(date).isNotEmpty;
                  return Container(
                    margin: const EdgeInsets.all(2.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          eventful ? OnlineTheme.green5 : OnlineTheme.darkGray,
                      shape: BoxShape.rectangle,
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: eventful
                              ? OnlineTheme.green5.lighten(50)
                              : Colors.white,
                          width: 2,
                        ),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: OnlineTheme.textStyle(weight: 5),
                    ),
                  );
                },
                defaultBuilder: (context, date, _) {
                  final events = getEventsForDay(date);

                  // TODO: Waitlist = Gul, Registered = Grønn

                  if (events.isNotEmpty) {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: OnlineTheme.green5,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(
                        date.day.toString(),
                        style: OnlineTheme.textStyle(weight: 5),
                      ),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: OnlineTheme.darkGray,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(
                        date.day.toString(),
                        style: OnlineTheme.textStyle(),
                      ),
                    );
                  }
                },
              ),
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  // color: Colors.grey.shade700,
                  color: OnlineTheme.gray0,
                  border: Border.fromBorderSide(
                      BorderSide(color: OnlineTheme.gray0, width: 2)),
                  // border: Border.fromBorderSide(BorderSide(color: OnlineTheme.gray9, width: 2)),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                markerDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: OnlineTheme.green5,
                  color: Colors.transparent,
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  // color: Colors.grey.shade700,
                  // color: Colors.transparent,
                  border: Border.fromBorderSide(
                      BorderSide(color: OnlineTheme.white, width: 2)),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon:
                    Icon(Icons.arrow_back_ios, color: Colors.white),
                rightChevronIcon:
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                titleTextStyle: TextStyle(color: Colors.white),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekendStyle: TextStyle(color: OnlineTheme.white),
                weekdayStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24 + 24),
            Text('Mine Arrangementer', style: OnlineTheme.header()),
            _buildEventList(upcomingEvents),
            const SizedBox(height: 24 + 24),
            Text('Tidligere Arrangementer', style: OnlineTheme.header()),
            _buildEventList(pastEvents),
            const SizedBox(height: 24),
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

class FeedPageDisplay extends StaticPage {
  const FeedPageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return const FeedPage();
  }
}
