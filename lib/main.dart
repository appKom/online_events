import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:online/router.dart';
import 'package:timezone/data/latest.dart' as tz;

import '/services/authenticator.dart';
import '/services/env.dart';
import '/services/secure_storage.dart';
import '/theme/theme.dart';
import 'core/client/client.dart';
import 'core/models/event_model.dart';
import 'firebase_options.dart';

List<EventModel> allAttendedEvents = [];

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// Initialization settings for Android
const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

// Initialization settings for iOS
const initializationSettingsIOS = DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
);

// Combined initialization settings
const initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsIOS,
);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.initialize();
  Authenticator.initialize();

  SecureStorage.initialize();
  tz.initializeTimeZones();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const OnlineApp());

  Client.getEvents(pages: [1]);
  Client.fetchArticles(1);

  await _configureFirebase();

  await Authenticator.fetchStoredCredentials();

  if (Authenticator.isLoggedIn()) {
    final user = await Client.getUserProfile();
    fetchAttendeeInfo(user!.id);
  }

  Client.getGroups();
}

Future _configureFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await messaging.subscribeToTopic('allUsers');
  await FirebaseMessaging.instance.getToken();
}

Future<void> fetchAttendeeInfo(int userId) async {
  List<int> attendedEventIds = [];

  await Client.getAttendanceEvents(userId: userId, page: 1);

  for (final event in Client.eventAttendanceCache.value) {
    attendedEventIds.add(event.eventId);
  }

  Map<String, EventModel>? fetchedEvents = await Client.getEventsWithIds(eventIds: attendedEventIds);
  if (fetchedEvents != null) {
    allAttendedEvents = fetchedEvents.values.toList();
  }

  //Temporary solution to prevent duplicate fetching
  Client.eventAttendanceCache.value.clear();
}

class OnlineApp extends StatelessWidget {
  const OnlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Online',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      color: OnlineTheme.current.bg,
    );
    // return MaterialApp(
    //   navigatorKey: AppNavigator.navigatorKey, // Use the single navigator key
    //   title: 'Online',
    //   debugShowCheckedModeBanner: false,
    //   home: const OnlineScaffold(
    //     showHeaderNavbar: true, // Default to showing header and navbar on HomePage
    //     child: HomePage(),
    //   ),
    // );
  }
}

// Routes
// /
// /calendar
// /groups:id
// /events/:id
// /articles/:id
// /profile
// /games
// /social/songs/:id
// /social/games/:id
