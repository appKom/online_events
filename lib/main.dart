import 'package:flutter/material.dart';
import 'package:online_events/models/list_event.dart';
import 'package:online_events/theme.dart';
import 'package:online_events/upcoming_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return MaterialApp(
      title: 'Online Events',
      debugShowCheckedModeBanner: false,
      color: OnlineTheme.background,
      home: Padding(
        padding: padding,
        child: UpcomingEventsList(
          models: testModels,
        ),
      ),
    );
  }
}

class UpcomingEventsList<T> extends StatelessWidget {
  final List<ListEventModel> models;

  const UpcomingEventsList({super.key, required this.models});

  @override
  Widget build(BuildContext context) {
    const upcomingEvents = TextStyle(
      fontFamily: OnlineTheme.font,
      fontWeight: FontWeight.w500,
      fontSize: 10,
      height: 1.5,
      color: OnlineTheme.gray12,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    );

    return Stack(
      children: [
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 15,
          child: Center(
            child: Text(
              'UPCOMING EVENTS',
              style: upcomingEvents,
            ),
          ),
        ),
        Positioned.fill(
          top: 15,
          child: ListView.builder(
            itemBuilder: buildItem,
            itemCount: testModels.length,
          ),
        ),
      ],
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return UpcomingCard(
      model: models[index],
    );
  }
}

final testModels = [
  ListEventModel(
    name: 'Buldring med OIL!',
    date: DateTime(2023, 9, 25),
    registered: 20,
    capacity: 20,
  ),
  ListEventModel(
    name: 'Bedriftspresentasjon med Sopra Steria',
    date: DateTime(2023, 9, 26),
    registered: 40,
    capacity: 40,
  ),
  ListEventModel(
    name: 'genVORS høst 2023',
    date: DateTime(2023, 9, 27),
    registered: 13,
    capacity: 200,
  ),
];
