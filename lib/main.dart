import 'package:flutter/material.dart';
import 'package:online_events/core/models/article_model.dart';
import 'package:online_events/core/models/attendance_model.dart';
import 'package:online_events/pages/drinking_games/drinking_games_page.dart';
import 'package:online_events/pages/home/home_page.dart';
import 'package:online_events/pages/login/auth_service.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import 'package:online_events/services/env.dart';
import 'package:online_events/services/secure_storage.dart';
import '/components/online_scaffold.dart';
import '/services/app_navigator.dart';
import 'core/client/client.dart';
import 'core/models/event_model.dart';
import 'theme/theme.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

bool loggedIn = false;
final List<EventModel> eventModels = [];
final List<ArticleModel> articleModels = [];
final List<AttendanceModel> attendanceModels = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.initialize();
  SecureStorage.initialize();

  runApp(const MainApp());

  // Listen for incoming links - deep links and URL schemes
  StreamSubscription? _sub = uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      // Handle the incoming URI
      handleIncomingLink(uri);
    }
  }, onError: (Object err) {
    // Handle error
    print('Error occurred: $err');
  });

  // Ensure the subscription is cancelled when the stream is closed
  _sub.onDone(() {
    _sub.cancel();
  });

  // Pre-fetch data if necessary (events, articles, attendances)
  final responses = await Future.wait([
    Client.getEvents(),
    Client.getArticles(),
    Client.getAttendance(),
  ]);

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
}

Future<Map<String, dynamic>?> exchangeCodeForToken(String code) async {
  try {
    final tokenData = await AuthService.exchangeCodeForToken(code);
    if (tokenData != null) {
      // Handle the received token data (e.g., store it, navigate to another page)
      return tokenData; // Return the token data if successful
    } else {
      // Handle error (token exchange failed)
      print("Failed to exchange code for token.");
      return null; // Return null if the token exchange fails
    }
  } catch (e) {
    // Handle any exceptions
    print("An error occurred while exchanging the code: $e");
    return null; // Return null in case of an exception
  }
}

void handleIncomingLink(Uri uri) {
  // Check if the URL is the callback URL
  if (uri.toString().startsWith(AuthService.redirectUri)) {
    final String? code = uri.queryParameters['code'];
    final String? state = uri.queryParameters['state'];

    // Verify that the 'state' is the same as the one you sent in the request
    if (state != null && AuthService.isValidState(state)) {
      if (code != null) {
        exchangeCodeForToken(code);
      }
    } else {
      // Handle state mismatch or error
      print("State value does not match, potential CSRF attack.");
    }
  }
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
      home: const OnlineScaffold(),
    );
  }
}
