import 'package:flutter/cupertino.dart';
import '/components/online_scaffold.dart';

abstract class PageNavigator {
  /// Replace scaffold content with widget
  static void navigateTo(OnlinePage page) => OnlineScaffold.page.value = page;
}

// This class is a service provider. Helping the user navigate the app is the service it provides.
abstract class AppNavigator {
  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  static const Duration transitionDuration = Duration(milliseconds: 0); // 250
  static const Duration reverseDuration = Duration(milliseconds: 0); // 250

  static void navigateToRoute(Route route, {required bool additive}) {
    if (additive) {
      navigator.currentState!.push(route);
    } else {
      navigator.currentState!.pushReplacement(route);
    }
  }

  static void pop() {
    navigator.currentState!.pop();
  }
}
