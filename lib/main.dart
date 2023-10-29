import 'package:flutter/material.dart';
import 'package:online_events/services/app_navigator.dart';
import 'pages/upcoming_events/upcoming_events_page.dart';
import '/theme.dart';

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
