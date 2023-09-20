import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/models/list_event.dart';
import '/upcoming_card.dart';
import '/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return MaterialApp(
      title: 'Online Events',
      debugShowCheckedModeBanner: false,
      color: OnlineTheme.background,
      home: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 17),
            SvgPicture.asset(
              'assets/header.svg',
              height: 48,
            ),
            Column(
              children: [
                const SizedBox(height: 60),
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: OnlineTheme.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                UpcomingEventsList(
                  models: testModels,
                ),
              ],
            ),
          ],
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

    return Column(
      children: [
        const SizedBox(
          height: 15,
          child: Center(
            child: Text(
              'UPCOMING EVENTS',
              style: upcomingEvents,
            ),
          ),
        ),
        const SizedBox(height: 10),
        buildItem(context, 0),
        buildItem(context, 1),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'MER',
              style: OnlineTheme.eventListSubHeader.copyWith(fontWeight: FontWeight.w500),
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
