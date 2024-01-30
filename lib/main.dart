import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '/components/online_scaffold.dart';
import '/pages/home/home_page.dart';
import '/services/app_navigator.dart';
import '/services/env.dart';
import '/services/secure_storage.dart';
import 'core/client/client.dart';
import 'core/models/user_model.dart';
import 'firebase_options.dart';
import 'theme/theme.dart';

bool loggedIn = false;
UserModel? userProfile;
int userId = 0;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.initialize();

  SecureStorage.initialize();
  await Client.loadTokensFromSecureStorage();

  if (!Client.tokenExpired()) {
    loggedIn = true;
    await Client.getUserProfile();
    
  } else if (await Client.fetchRefreshToken()) {
    loggedIn = true;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());

  PageNavigator.navigateTo(const HomePage());

  final messaging = FirebaseMessaging.instance;

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

  Client.getEvents(pages: [1]);
  Client.fetchArticles();

  await FirebaseMessaging.instance.getToken();
}

// final List<EventModel> eventModels = [];
// final List<ArticleModel> articleModels = [];

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
