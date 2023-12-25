import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/core/client/client.dart';
import '/core/models/attended_events.dart';
import '/core/models/event_model.dart';
import '/main.dart';
import '/pages/home/event_card.dart';
import '/pages/loading/loading_display_page.dart';
import '/pages/login/auth_web_view_page.dart';
import '/pages/profile/profile_page.dart';
import '/theme/theme.dart';

List<AttendedEvents> attendedEvents = [];
List<EventModel> pastEventModels = [];

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});

  @override
  MyEventsPageState createState() => MyEventsPageState();
}

class MyEventsPageState extends State<MyEventsPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isDisposed = false;
  bool _isLoading = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    if (loggedIn) {
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
    int nextPage1 = currentPage + 1;
    int nextPage2 = currentPage + 2;
    int nextPage3 = currentPage + 3;

    try {
      var moreEventsPage1 = await Client.getEvents(pages: [nextPage1]);
      var moreEventsPage2 = await Client.getEvents(pages: [nextPage2]);
      var moreEventsPage3 = await Client.getEvents(pages: [nextPage3]);

      if (mounted) {
        setState(() {
          if (moreEventsPage1 != null) {
            for (var event in moreEventsPage1) {
              if (!eventModels
                  .any((existingEvent) => existingEvent.id == event.id)) {
                eventModels.add(event);
              }
            }
          }
          if (moreEventsPage2 != null) {
            for (var event in moreEventsPage2) {
              if (!eventModels
                  .any((existingEvent) => existingEvent.id == event.id)) {
                eventModels.add(event);
              }
            }
          }
          if (moreEventsPage3 != null) {
            for (var event in moreEventsPage3) {
              if (!eventModels
                  .any((existingEvent) => existingEvent.id == event.id)) {
                eventModels.add(event);
              }
            }
          }
          currentPage += 2;
        });
      }
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

  Future<void> fetchAttendeeInfo() async {
    List<AttendedEvents> allAttendees = await Client.getAttendedEvents(userId);
    if (mounted) {
      setState(() {
        attendedEvents = allAttendees;
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

  Widget _customDaysOfWeekBuilder(BuildContext context, int i) {
    return Center(
      child: Text(
        _norwegianWeekDays[i % 7],
        style: OnlineTheme.textStyle(),
      ),
    );
  }

  static const List<String> _norwegianMonths = [
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

  // Custom Header Widget
  Widget _customHeaderWidget({
    required DateTime focusedDay,
    required VoidCallback onLeftArrowTap,
    required VoidCallback onRightArrowTap,
    required VoidCallback onTitleTap,
  }) {
    String monthName = _norwegianMonths[focusedDay.month - 1];
    int year = focusedDay.year;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: onLeftArrowTap,
        ),
        GestureDetector(
          onTap: onTitleTap,
          child: Text('$monthName $year',
              style: OnlineTheme.textStyle(size: 16, color: OnlineTheme.white)),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: onRightArrowTap,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const LoadingPageDisplay();
    }
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    final style = OnlineTheme.textStyle(size: 20, weight: 7);
    if (loggedIn) {
      final now = DateTime.now();

      final upcomingEvents = eventModels
          .where((model) => attendedEvents
              .any((attendedEvent) => attendedEvent.event == model.id))
          .where((model) {
        final eventDate = DateTime.parse(model.startDate);
        return eventDate.isAfter(now);
      }).toList();

      final pastEvents = eventModels
          .where((model) => attendedEvents
              .any((attendedEvent) => attendedEvent.event == model.id))
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

      Widget _buildCustomWeekdayHeaders() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _norwegianWeekDays
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: OnlineTheme.textStyle(), // Your desired style
                      ),
                    ),
                  ))
              .toList(),
        );
      }

      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: OnlineHeader.height(context) + 20),
              Center(
                child: Text('Mine Arrangementer', style: style),
              ),
              _customHeaderWidget(
                focusedDay: _focusedDay,
                onLeftArrowTap: () {
                  setState(() {
                    _focusedDay = DateTime(_focusedDay.year,
                        _focusedDay.month - 1, _focusedDay.day);
                  });
                },
                onRightArrowTap: () {
                  setState(() {
                    _focusedDay = DateTime(_focusedDay.year,
                        _focusedDay.month + 1, _focusedDay.day);
                  });
                },
                onTitleTap: () {
                  // Define what happens when the title is tapped, if needed
                },
              ),
              _buildCustomWeekdayHeaders(),
              TableCalendar(
                headerVisible: false,
                daysOfWeekVisible: false,
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,

                // rowHeight: 55.0,
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
                  defaultBuilder: (context, date, _) {
                    var events = getEventsForDay(date);
                    if (events.isNotEmpty) {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: OnlineTheme.green5,
                          shape: BoxShape.rectangle,
                        ),
                        child: Text(
                          date.day.toString(),
                          style: OnlineTheme.textStyle(),
                        ),
                      );
                    } else {
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: OnlineTheme.gray0,
                            shape: BoxShape.rectangle),
                        child: Text(
                          date.day.toString(),
                          style: OnlineTheme.textStyle(),
                        ),
                      );
                    }
                  },
                ),
                calendarStyle: CalendarStyle(
                  defaultDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: OnlineTheme.gray16,
                  ),
                  weekendDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: OnlineTheme.gray16,
                  ),
                  selectedDecoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: OnlineTheme.gray10,
                  ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey.shade700,
                  ),
                  markerDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: OnlineTheme.green5,
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
              const SizedBox(
                height: 10,
              ),
              const Separator(
                margin: 5,
              ),
              _buildEventList(upcomingEvents),
              const SizedBox(height: 15),
              Center(
                child: Text('Tidligere Arrangementer', style: style),
              ),
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
    } else {
      void onPressed() {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginWebView(),
        ));
      }

      return Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: OnlineHeader.height(context)),
              Center(
                child: Text(
                  'Du må være inlogget for å se dine arrangementer',
                  style: OnlineTheme.textStyle(),
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              AnimatedButton(
                  onTap: onPressed,
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: OnlineTheme.buttonHeight,
                      decoration: BoxDecoration(
                        gradient: OnlineTheme.greenGradient,
                        borderRadius: OnlineTheme.buttonRadius,
                      ),
                      child: Center(
                        child: Text(
                          'Logg Inn',
                          style: OnlineTheme.textStyle(weight: 5),
                        ),
                      ),
                    );
                  })
            ],
          ));
    }
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

class MyEventsPageDisplay extends StaticPage {
  const MyEventsPageDisplay({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const MyEventsPage();
  }
}
