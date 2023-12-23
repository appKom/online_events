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

  @override
  void initState() {
    super.initState();
    if (loggedIn == true) {
      fetchMoreEvents();
      fetchAttendeeInfo();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void fetchMoreEvents() async {
    var moreEvents = await Client.getEvents(pages: [5, 6, 7]);
    if (moreEvents != null) {
      setState(() {
        eventModels.addAll(moreEvents);
      });
    }
  }

  Future<void> fetchAttendeeInfo() async {
    List<AttendedEvents> allAttendees = await Client.getAttendedEvents(userId);
    if (!_isDisposed) {
      setState(() {
        attendedEvents = allAttendees;
        _isLoading = false;
      });
    }
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
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    final style = OnlineTheme.textStyle(size: 20, weight: 7);
    if (loggedIn) {
      final now = DateTime.now();

      final upcomingEvents = eventModels
          .where((model) => attendedEvents.any((attendedEvent) => attendedEvent.event == model.id))
          .where((model) {
        final eventDate = DateTime.parse(model.startDate);
        return eventDate.isAfter(now);
      }).toList();

      final pastEvents = eventModels
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
              TableCalendar(
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
                        decoration: const BoxDecoration(color: OnlineTheme.gray0, shape: BoxShape.rectangle),
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
              const Separator(
                margin: 5,
              ),
              _buildEventList(upcomingEvents),
              const SizedBox(height: 15),
              Center(
                child: Text('Tidligere Arrangementer', style: style),
              ),
              _buildEventList(pastEvents),
              SizedBox(height: Navbar.height(context)),
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
