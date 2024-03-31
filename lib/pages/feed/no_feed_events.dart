import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '/theme/theme.dart';
import 'calendar_card.dart';

class NoFeedEvents extends StatefulWidget {
  const NoFeedEvents({
    super.key,
  });
  @override
  NoFeedEventsState createState() => NoFeedEventsState();
}

class NoFeedEventsState extends State<NoFeedEvents> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

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
    return Padding(
      padding: MediaQuery.of(context).padding + OnlineTheme.horizontalPadding,
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
              },
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(2.0),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: OnlineTheme.darkGray,
                      shape: BoxShape.rectangle,
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: OnlineTheme.textStyle(weight: 5),
                    ),
                  );
                },
                defaultBuilder: (context, date, _) {
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
            const SizedBox(height: 48),
            Text(
              'Du har ingen arrangementer',
              style: OnlineTheme.textStyle(size: 22),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
