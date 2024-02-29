import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_scaffold.dart';
import '/components/skeleton_loader.dart';
import '/core/client/client.dart';
import '/core/models/attended_events.dart';
import '/core/models/event_model.dart';
import '/pages/home/event_card.dart';
import '/services/authenticator.dart';
import '/theme/theme.dart';

List<AttendedEvents> attendedEvents = [];
List<EventModel> pastEventModels = [];

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
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    final time = DateTime.now();
    String monthName = norwegianMonths[time.month - 1];
    int year = time.year;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text('Mine Arrangementer', style: OnlineTheme.header()),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$monthName $year', style: OnlineTheme.textStyle(size: 16, color: OnlineTheme.white)),
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
  DateTime? _selectedDay;
  bool _isLoading = true;
  int currentPage = 1;

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
    final moreEventsPage1 = await Client.getEvents(pages: [currentPage + 1, currentPage + 2]);

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
        currentPage += 3;
      });
    }
  }

  Future<void> fetchAttendeeInfo() async {
    final user = Client.userCache.value;

    if (user == null) return;

    // TODO: This is a bit of a hack
    List<AttendedEvents> allAttendees = await Client.getAttendedEvents(user.id) ?? [];
    if (mounted) {
      setState(() {
        attendedEvents = allAttendees;
        _isLoading = false;
      });
    }
  }

  static const List<String> _norwegianWeekDays = ['Man', 'Tir', 'Ons', 'Tor', 'Fre', 'Lør', 'Søn'];

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
          Text('$monthName $year', style: OnlineTheme.textStyle(size: 16, color: OnlineTheme.white)),
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
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    final now = DateTime.now();

    final upcomingEvents = Client.eventsCache.value
        .where((model) => attendedEvents.any((attendedEvent) => attendedEvent.event == model.id))
        .where((model) {
      final eventDate = DateTime.parse(model.startDate);
      return eventDate.isAfter(now);
    }).toList();

    final pastEvents = Client.eventsCache.value
        .where((model) => attendedEvents.any((attendedEvent) => attendedEvent.event == model.id))
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
        final comparisonDayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);

        return (startDate.isAtSameMomentAs(comparisonDayStart) || startDate.isBefore(comparisonDayEnd)) &&
            (endDate.isAtSameMomentAs(comparisonDayStart) || endDate.isAfter(comparisonDayStart));
      }

      selectedEvents.addAll(upcomingEvents.where((event) => isEventOnDay(event, day)));
      selectedEvents.addAll(pastEvents.where((event) => isEventOnDay(event, day)));

      return selectedEvents;
    }

    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text('Mine Arrangementer', style: OnlineTheme.header()),
            const SizedBox(height: 10),
            _customHeaderWidget(
              focusedDay: _focusedDay,
              onLeftArrowTap: () {
                setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                });
              },
              onRightArrowTap: () {
                setState(() {
                  _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
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
              },
              eventLoader: (day) => getEventsForDay(day),
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, focusedDay) {
                  final eventful = getEventsForDay(date).isNotEmpty;
                  return Container(
                    margin: const EdgeInsets.all(2.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: eventful ? OnlineTheme.green5 : OnlineTheme.gray13,
                      shape: BoxShape.rectangle,
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: eventful ? OnlineTheme.green5.lighten(50) : Colors.white,
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
                        color: OnlineTheme.gray13,
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
                  border: Border.fromBorderSide(BorderSide(color: OnlineTheme.gray0, width: 2)),
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
                  border: Border.fromBorderSide(BorderSide(color: OnlineTheme.white, width: 2)),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.arrow_back_ios, color: Colors.white),
                rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                titleTextStyle: TextStyle(color: Colors.white),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekendStyle: TextStyle(color: OnlineTheme.white),
                weekdayStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildEventList(upcomingEvents),
            const SizedBox(height: 24),
            Text('Tidligere Arrangementer', style: OnlineTheme.header()),
            _buildEventList(pastEvents),
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

  Widget _buildEventList(List<EventModel> events) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 111.0 * events.length,
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
