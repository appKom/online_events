import 'package:flutter/material.dart';

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // No animation; the child is simply returned as is
    return child;
  }
}

// This class is a service provider. Helping the user navigate the app is the service it provides.
abstract class AppNavigator {
  static GlobalKey<NavigatorState> globalNavigator = GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> onlineNavigator = GlobalKey<NavigatorState>();

  static const Duration transitionDuration = Duration(milliseconds: 0); // 250
  static const Duration reverseDuration = Duration(milliseconds: 0); // 250

  static void replaceWithPage(Widget page) {
    // onlineNavigator.currentState!.pushReplacement(Ma)
    Route route = NoAnimationPageRoute(
      builder: (context) => page,
    );

    onlineNavigator.currentState!.pushAndRemoveUntil(route, (route) => false);
  }

  static void globalNavigateTo(Widget page) {
    final route = MaterialPageRoute(
      builder: (context) => page,
    );

    globalNavigator.currentState!.push(route);
  }

  static void navigateToPage(Widget page) {
    final route = MaterialPageRoute(
      builder: (context) => page,
    );

    onlineNavigator.currentState!.push(route);
  }

  static void navigateToRoute(Route route, {required bool additive}) {
    if (additive) {
      globalNavigator.currentState!.push(route);
    } else {
      globalNavigator.currentState!.pushReplacement(route);
    }
  }

  static void pop() {
    globalNavigator.currentState!.pop();
  }
}
