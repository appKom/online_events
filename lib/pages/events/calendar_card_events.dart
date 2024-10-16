// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// import '/core/models/event_model.dart';
// import '/services/app_navigator.dart';
// import '/theme/theme.dart';
// import '../event/event_page.dart';

// final List<String> norwegianMonths = [
//   'Januar',
//   'Februar',
//   'Mars',
//   'April',
//   'Mai',
//   'Juni',
//   'Juli',
//   'August',
//   'September',
//   'Oktober',
//   'November',
//   'Desember'
// ];

// class CalendarCardEvents extends StatefulWidget {
//   final List<EventModel> upcomingEvents;
//   final List<EventModel> pastEvents;

//   const CalendarCardEvents({super.key, required this.upcomingEvents, required this.pastEvents});

//   @override
//   CalendarCardEventsState createState() => CalendarCardEventsState();
// }

// class CalendarCardEventsState extends State<CalendarCardEvents> {
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay = DateTime.now();

//   static const List<String> _norwegianWeekDays = ['Man', 'Tir', 'Ons', 'Tor', 'Fre', 'Lør', 'Søn'];

//   static Widget customDaysOfWeekBuilder(BuildContext context, int i) {
//     return Center(
//       child: Text(
//         _norwegianWeekDays[i % 7],
//         style: OnlineTheme.textStyle(),
//       ),
//     );
//   }

//   Widget _customHeaderWidget({
//     required DateTime focusedDay,
//     required VoidCallback onLeftArrowTap,
//     required VoidCallback onRightArrowTap,
//   }) {
//     String monthName = norwegianMonths[focusedDay.month - 1];
//     int year = focusedDay.year;

//     return SizedBox(
//       height: 50,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back_ios),
//             onPressed: onLeftArrowTap,
//           ),
//           Text('$monthName $year', style: OnlineTheme.textStyle(size: 16)),
//           IconButton(
//             icon: const Icon(Icons.arrow_forward_ios),
//             onPressed: onRightArrowTap,
//           ),
//         ],
//       ),
//     );
//   }

//   static Widget buildCustomWeekdayHeaders() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: _norwegianWeekDays
//           .map(
//             (day) => Expanded(
//               child: Center(
//                 child: Text(
//                   day,
//                   style: OnlineTheme.textStyle(),
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = OnlineTheme.current;

//     List<EventModel> getEventsForDay(DateTime day) {
//       List<EventModel> selectedEvents = [];

//       bool isEventOnDay(EventModel event, DateTime day) {
//         final startDate = DateTime.parse(event.startDate).toLocal();
//         final endDate = DateTime.parse(event.endDate).toLocal();
//         final comparisonDayStart = DateTime(day.year, day.month, day.day);
//         final comparisonDayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);

//         return (startDate.isAtSameMomentAs(comparisonDayStart) || startDate.isBefore(comparisonDayEnd)) &&
//             (endDate.isAtSameMomentAs(comparisonDayStart) || endDate.isAfter(comparisonDayStart));
//       }

//       selectedEvents.addAll(widget.upcomingEvents.where((event) => isEventOnDay(event, day)));
//       selectedEvents.addAll(widget.pastEvents.where((event) => isEventOnDay(event, day)));

//       return selectedEvents;
//     }

//     return Column(
//       children: [
//         _customHeaderWidget(
//           focusedDay: _focusedDay,
//           onLeftArrowTap: () {
//             setState(() {
//               _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
//             });
//           },
//           onRightArrowTap: () {
//             setState(() {
//               _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
//             });
//           },
//         ),
//         buildCustomWeekdayHeaders(),
//         TableCalendar(
//           headerVisible: false,
//           daysOfWeekVisible: false,
//           calendarFormat: CalendarFormat.month,
//           startingDayOfWeek: StartingDayOfWeek.monday,
//           availableCalendarFormats: const {CalendarFormat.month: ''},
//           onPageChanged: (focusedDay) {
//             setState(() {
//               _focusedDay = focusedDay;
//             });
//           },
//           focusedDay: _focusedDay,
//           firstDay: DateTime(2000),
//           lastDay: DateTime(2100),
//           selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//           onDaySelected: (selectedDay, focusedDay) {
//             setState(() {
//               _selectedDay = selectedDay;
//               _focusedDay = focusedDay;
//             });
//             List<EventModel> eventsForSelectedDay = getEventsForDay(selectedDay);

//             if (eventsForSelectedDay.isNotEmpty) {
//               AppNavigator.navigateToPage(EventPageDisplay(model: eventsForSelectedDay.first));
//             }
//           },
//           eventLoader: (day) => getEventsForDay(day),
//           calendarBuilders: CalendarBuilders(
//             selectedBuilder: (context, date, focusedDay) {
//               final events = getEventsForDay(date);
//               final eventful = getEventsForDay(date).isNotEmpty;
//               Color determineColor(EventModel event) {
//                 switch (event.eventType) {
//                   case 2:
//                     return theme.neg;
//                   case 3:
//                     return Colors.blue;
//                   default:
//                     return theme.posBg;
//                 }
//               }

//               if (eventful) {
//                 return Container(
//                   margin: const EdgeInsets.all(2.0),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: eventful ? determineColor(events.first) : theme.card,
//                     shape: BoxShape.rectangle,
//                     border: Border.fromBorderSide(
//                       BorderSide(
//                         color: eventful ? theme.pos : theme.fg,
//                         width: 2,
//                       ),
//                     ),
//                     borderRadius: const BorderRadius.all(Radius.circular(5)),
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         date.day.toString(),
//                         style: OnlineTheme.textStyle(weight: 5),
//                       ),
//                       // Text(
//                       //   events.first.title,
//                       //   style: OnlineTheme.textStyle(size: 10),
//                       //   overflow: TextOverflow.ellipsis,
//                       // ),
//                     ],
//                   ),
//                 );
//               }
//               return null;
//             },
//             defaultBuilder: (context, date, _) {
//               final events = getEventsForDay(date);

//               Color determineColor(EventModel event) {
//                 switch (event.eventType) {
//                   case 2:
//                     return theme.neg;
//                   case 3:
//                     return Colors.blue;
//                   default:
//                     return theme.pos;
//                 }
//               }

//               if (events.isNotEmpty) {
//                 return Container(
//                   margin: const EdgeInsets.all(4.0),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: events.isNotEmpty ? determineColor(events.first) : OnlineTheme.current.card,
//                     shape: BoxShape.rectangle,
//                     borderRadius: const BorderRadius.all(Radius.circular(5)),
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         date.day.toString(),
//                         style: OnlineTheme.textStyle(weight: 5),
//                       ),
//                     ],
//                   ),
//                 );
//               } else {
//                 return Container(
//                   margin: const EdgeInsets.all(4.0),
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: OnlineTheme.current.card,
//                     shape: BoxShape.rectangle,
//                     borderRadius: const BorderRadius.all(Radius.circular(5)),
//                   ),
//                   child: Text(
//                     date.day.toString(),
//                     style: OnlineTheme.textStyle(),
//                   ),
//                 );
//               }
//             },
//           ),
//           calendarStyle: CalendarStyle(
//             todayDecoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               color: theme.muted,
//               border: Border.fromBorderSide(BorderSide(color: theme.muted, width: 2)),
//               borderRadius: const BorderRadius.all(Radius.circular(5)),
//             ),
//             markerDecoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.transparent,
//             ),
//             selectedDecoration: BoxDecoration(
//               shape: BoxShape.rectangle,
//               border: Border.fromBorderSide(BorderSide(color: theme.fg, width: 2)),
//               borderRadius: const BorderRadius.all(Radius.circular(5)),
//             ),
//           ),
//           headerStyle: HeaderStyle(
//             formatButtonVisible: false,
//             titleCentered: true,
//             leftChevronIcon: Icon(Icons.arrow_back_ios, color: theme.fg),
//             rightChevronIcon: Icon(Icons.arrow_forward_ios, color: theme.fg),
//             titleTextStyle: TextStyle(color: theme.fg),
//           ),
//           daysOfWeekStyle: DaysOfWeekStyle(
//             weekendStyle: TextStyle(color: theme.fg),
//             weekdayStyle: TextStyle(color: theme.fg),
//           ),
//         ),
//       ],
//     );
//   }
// }
