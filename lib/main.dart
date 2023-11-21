import 'package:flutter/material.dart';
import 'package:online_events/core/models/article_model.dart';
import 'package:online_events/core/models/attendance_model.dart';
import 'package:online_events/pages/home/home_page.dart';
import 'package:online_events/services/env.dart';
import 'package:online_events/services/secure_storage.dart';
import '/components/online_scaffold.dart';
import '/services/app_navigator.dart';
import 'core/client/client.dart';
import 'core/models/event_model.dart';
import 'theme/theme.dart';

bool loggedIn = false;

Future main() async {
  runApp(const MainApp());

  await Env.initialize();
  SecureStorage.initialize();

  Future.wait([Client.getEvents(), Client.getArticles(), Client.getAttendance()]).then((responses) {
    final events = responses[0] as List<EventModel>?;
    final articles = responses[1] as List<ArticleModel>?;
    final attendances = responses[2] as List<AttendanceModel>?;

    if (events != null) {
      eventModels.addAll(events);
    }

    if (articles != null) {
      articleModels.addAll(articles);
    }

    if (attendances != null) {
      attendanceModels.addAll(attendances);
    }

    PageNavigator.navigateTo(const HomePage());
  });
}

final List<EventModel> eventModels = [];
final List<ArticleModel> articleModels = [];
final List<AttendanceModel> attendanceModels = [];

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.navigator,
      title: 'Online Events',
      debugShowCheckedModeBanner: false,
      color: OnlineTheme.background,
      home: const OnlineScaffold(),
    );
  }
}
