import 'package:flutter/material.dart';
import 'pages/upcoming_events/upcoming_events_page.dart';
import '/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Online Events',
      debugShowCheckedModeBanner: false,
      color: OnlineTheme.background,
      home: UpcomingEventsPage(),
    );
  }
}
