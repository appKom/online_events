import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:timezone/data/latest.dart' as tz;

import '/components/online_scaffold.dart';
import '/services/app_navigator.dart';
import '/services/env.dart';
import '/services/secure_storage.dart';
import 'core/client/client.dart';
import 'core/models/user_model.dart';
import 'firebase_options.dart';

bool loggedIn = false;
UserModel? userProfile;
int userId = 0;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> checkAndRequestPermission(BuildContext context) async {
  final AndroidFlutterLocalNotificationsPlugin? androidPlatform =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  final bool? hasPermission = await androidPlatform?.requestExactAlarmsPermission();

  if (hasPermission == null || !hasPermission) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Exact alarm permission is required for reminders. Please enable it in settings.'),
        action: SnackBarAction(
          label: 'Open Settings',
          onPressed: () => openAppSettings(),
        ),
      ),
    );
  }
}

void openAppSettings() {
  const AndroidIntent intent = AndroidIntent(
    action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
  );
  intent.launch();
}

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

  SecureStorage.initialize();
  tz.initializeTimeZones();

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await Client.loadTokensFromSecureStorage();

  if (!Client.tokenExpired()) {
    loggedIn = true;
    userProfile = await Client.getUserProfile();
    userId = userProfile?.id ?? 0;
  } else if (await Client.fetchRefreshToken()) {
    loggedIn = true;
  }

  runApp(const OnlineApp());

  Client.getEvents(pages: [1]);
  Client.fetchArticles(1);

  await _configureFirebase();
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

  await FirebaseMessaging.instance.getToken();
}

class OnlineApp extends StatelessWidget {
  const OnlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        navigatorKey: AppNavigator.globalNavigator,
        title: 'Online',
        debugShowCheckedModeBanner: false,
        home: const OnlineScaffold(),
      ),
    );
  }
}

// For all badges, use the traffic light model
// Red = påmelding ikke åpen (enten ikke åpnet enda, eller over)
// Green = ledige plasser
// Yellow = venteliste