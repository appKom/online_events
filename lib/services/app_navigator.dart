import 'package:flutter/material.dart';

// This class is a service provider. Helping the user navigate the app is the service it provides.
class AppNavigator {
  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  static const Duration transitionDuration = Duration(milliseconds: 0); // 250
  static const Duration reverseDuration = Duration(milliseconds: 0); // 250

  /// Navigates to target widget.
  static void navigateTo(Widget target, {required bool additive}) {
    final route = PageRouteBuilder(
      transitionDuration: transitionDuration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Animation is for animating to
        // Secondary animation is for animating from
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: ((context, animation, secondaryAnimation) {
        return target;
      }),
    );

    navigateToRoute(route, additive: additive);
  }

  static void navigateToRoute(Route route, {required bool additive}) {
    navigator.currentState!.push(route).then((value) {
      if (!additive) navigator.currentState!.pushAndRemoveUntil(route, (route) => false);
    });
  }

  static void pop() {
    navigator.currentState!.pop();
  }
}
