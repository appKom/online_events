import 'package:flutter/material.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/pages/home/event_card_loggedin.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../theme/theme.dart';
import '/main.dart';

List<int> registeredEvents = [];

class MyEventsPageLoggedIn extends StatefulWidget {
  const MyEventsPageLoggedIn({Key? key}) : super(key: key);

  @override
  _MyEventsPageLoggedInState createState() => _MyEventsPageLoggedInState();
}

class _MyEventsPageLoggedInState extends State<MyEventsPageLoggedIn> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _populateRegisteredEvents();
  }

  void _populateRegisteredEvents() {
    registeredEvents = attendeeInfoModels
        .where((attendeeInfo) => attendeeInfo.isAttendee)
        .map((attendeeInfo) => attendeeInfo.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    final style = OnlineTheme.textStyle(size: 20, weight: 7);
    final now = DateTime.now();

    // Filter for upcoming registered events
    final upcomingEvents = eventModels
        .where((model) => registeredEvents.contains(model.id))
        .where((model) {
      final eventDate = DateTime.parse(model.startDate);
      return eventDate.isAfter(now);
    }).toList();

    // Filter for past registered events
    final pastEvents = eventModels
        .where((model) => registeredEvents.contains(model.id))
        .where((model) {
      final eventDate = DateTime.parse(model.startDate);
      return eventDate.isBefore(now);
    }).toList();

    List<EventModel> getEventsForDay(DateTime day) {
      return upcomingEvents.where((event) {
        final startDate = DateTime.parse(event.startDate);
        final endDate = DateTime.parse(event.endDate);
        return day.isAtSameMomentAs(startDate) ||
            day.isAtSameMomentAs(endDate) ||
            (day.isAfter(startDate) && day.isBefore(endDate));
      }).toList();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: OnlineHeader.height(context) + 40),
            Center(
              child: Text('Mine Arrangementer', style: style),
            ),
            _buildEventList(upcomingEvents),
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
                        color: Colors.green, 
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
                          color: OnlineTheme.gray16, shape: BoxShape.rectangle),
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
                  color:
                      OnlineTheme.gray16,
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
                  color: Colors.white,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon:
                    Icon(Icons.arrow_back_ios, color: Colors.white),
                rightChevronIcon:
                    Icon(Icons.arrow_forward_ios, color: Colors.white),
                titleTextStyle:
                    TextStyle(color: Colors.white), 
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekendStyle: TextStyle(
                    color: OnlineTheme.white), 
                weekdayStyle:
                    TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text('Tidligere Arrangementer', style: style),
            ),
            _buildEventList(pastEvents),
            SizedBox(height: Navbar.height(context)),
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
        itemBuilder: (context, index) => EventCardLoggedIn(
          model: events[index],
          attendeeInfoModel:
              attendeeInfoModels[index], // Ensure this list aligns with events
          attendeeInfoModels: attendeeInfoModels,
        ),
      ),
    );
  }
}
