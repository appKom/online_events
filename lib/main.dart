import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online_events/core/models/article_model.dart';
import 'package:online_events/pages/home/home_page.dart';
import 'package:online_events/services/env.dart';
import 'package:online_events/services/secure_storage.dart';
import '/components/online_scaffold.dart';
import '/services/app_navigator.dart';
import 'core/client/client.dart';
import 'core/models/event_model.dart';
import 'theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

bool loggedIn = false;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'lib/.env');
  await Env.initialize();

  SecureStorage.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  String? token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    print("FCM Registration Token: $token");
    // You can now use this token to send push notifications to this device
  } else {
    print("Failed to get FCM token");
  }

  Future.wait([Client.getEvents(), Client.getArticles()]).then((responses) {
    final events = responses[0] as List<EventModel>?;
    final articles = responses[1] as List<ArticleModel>?;

    if (events != null) {
      eventModels.addAll(events);
    }

    if (articles != null) {
      articleModels.addAll(articles);
    }

    PageNavigator.navigateTo(const HomePage());
  });
}

final List<EventModel> eventModels = [];
final List<ArticleModel> articleModels = [];

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
