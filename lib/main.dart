import 'package:flutter/material.dart';
import 'models/list_event.dart';
import 'pages/home/home_page.dart';
import '/services/app_navigator.dart';
import '/theme.dart';

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

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.navigator,
      title: 'Online Events',
      debugShowCheckedModeBanner: false,
      color: OnlineTheme.background,
      home: const UpcomingEventsPage(),
      // home: EventPage(),
    );
  }
}
