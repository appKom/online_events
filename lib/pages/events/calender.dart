import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/models/event_model.dart';
import '../../services/app_navigator.dart';
import '../../theme/theme.dart';
import '../event/event_page.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage(
      {super.key, required this.upcomingEvents, required this.pastEvents});

  final List<EventModel> upcomingEvents;
  final List<EventModel> pastEvents;

  @override
  CalenderPageState createState() => CalenderPageState();
}

class CalenderPageState extends State<CalenderPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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

    selectedEvents.addAll(
        widget.upcomingEvents.where((event) => isEventOnDay(event, day)));
    selectedEvents
        .addAll(widget.pastEvents.where((event) => isEventOnDay(event, day)));

    return selectedEvents;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
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
        List<EventModel> eventsForSelectedDay = getEventsForDay(selectedDay);

        if (eventsForSelectedDay.isNotEmpty) {
          AppNavigator.replaceWithPage(
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
              color: eventful ? OnlineTheme.green5 : OnlineTheme.darkGray,
              shape: BoxShape.rectangle,
              border: Border.fromBorderSide(
                BorderSide(
                  color:
                      eventful ? OnlineTheme.green5.lighten(50) : Colors.white,
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
        leftChevronIcon: Icon(Icons.arrow_back_ios, color: Colors.white),
        rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: OnlineTheme.white),
        weekdayStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
