import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import '/components/online_scaffold.dart';
import '/services/app_navigator.dart';
import '/services/authenticator.dart';
import '/services/env.dart';
import '/services/secure_storage.dart';
import 'core/client/client.dart';
import 'core/models/event_model.dart';
import 'firebase_options.dart';

List<EventModel> allAttendedEvents = [];
List<int> attendedEventIds = [];

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Initialization settings for Android
const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

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

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const OnlineApp());

  Client.getEvents(pages: [1]);
  Client.fetchArticles(1);

  await _configureFirebase();

  await Authenticator.fetchStoredCredentials();

  if (Authenticator.isLoggedIn()) {
    await Client.getUserProfile();
  }
  fetchAttendeeInfo();
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

Future<void> fetchAttendeeInfo() async {
  final user = Client.userCache.value;

  if (user == null) return;

  await Client.getAttendanceEventsStart(userId: user.id);

  for (final event in Client.eventAttendanceCache.value) {
    attendedEventIds.add(event.id);
  }
  // print('Number of pages is: $numberOfPages');
  Set<EventModel>? fetchedEvents =
      await Client.getEventsWithIds(eventIds: attendedEventIds);
  if (fetchedEvents != null) {
    allAttendedEvents = fetchedEvents.toList();
  }
}

class OnlineApp extends StatelessWidget {
  const OnlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.globalNavigator,
      title: 'Online',
      debugShowCheckedModeBanner: false,
      home: const OnlineScaffold(),
    );
  }
}
