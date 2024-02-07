import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
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

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.initialize();

  SecureStorage.initialize();
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
    return MaterialApp(
      navigatorKey: AppNavigator.globalNavigator,
      title: 'Online Events',
      debugShowCheckedModeBanner: false,
      home: const OnlineScaffold(),
    );
  }
}
