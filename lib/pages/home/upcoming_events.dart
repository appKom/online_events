import 'package:flutter/material.dart';
import '/models/list_event.dart';
import 'event_card.dart';

// class UpcomingEventsList extends StatelessWidget {
//   final List<ListEventModel> models;

//   const UpcomingEventsList({super.key, required this.models});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         buildItem(context, 0),
//         buildItem(context, 1),
//         const SizedBox(height: 10),
//       ],
//     );
//   }

//   Widget buildItem(BuildContext context, int index) {
//     return UpcomingCard(
//       model: models[index],
//     );
//   }
// }

// final testModels = [
//   ListEventModel(
//     name: 'Buldring med OIL!',
//     date: DateTime(2023, 9, 25),
//     registered: 20,
//     capacity: 20,
//   ),
//   ListEventModel(
//     name: 'Bedriftspresentasjon med Sopra Steria',
//     date: DateTime(2023, 9, 26),
//     registered: 40,
//     capacity: 40,
//   ),
//   ListEventModel(
//     name: 'genVORS høst 2023',
//     date: DateTime(2023, 9, 27),
//     registered: 13,
//     capacity: 200,
//   ),
// ];
