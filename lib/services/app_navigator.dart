import 'package:flutter/material.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '/components/online_scaffold.dart';

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
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void navigateToPage(Widget page, {bool withHeaderNavbar = true}) {
    final route = SwipeablePageRoute(
      builder: (context) => OnlineScaffold(
        showHeaderNavbar: withHeaderNavbar, // Pass the flag
        child: page,
      ),
    );

    navigatorKey.currentState!.push(route);
  }

  static void replaceWithPage(Widget page, {bool withHeaderNavbar = true}) {
    final route = NoAnimationPageRoute(
      builder: (context) => OnlineScaffold(
        showHeaderNavbar: withHeaderNavbar, // Pass the flag
        child: page,
      ),
    );

    navigatorKey.currentState!.pushReplacement(route);
  }

  static void navigateToRoute(Route route, {required bool withHeaderNavbar, bool additive = true}) {
    Route wrappedRoute;

    if (withHeaderNavbar) {
      // Wrap the existing route's page in OnlineScaffold
      wrappedRoute = MaterialPageRoute(
        builder: (context) => OnlineScaffold(
          showHeaderNavbar: withHeaderNavbar,
          child: (route.settings as MaterialPageRoute).builder(context),
        ),
      );
    } else {
      wrappedRoute = route; // Keep the original route if no header/navbar is required
    }

    if (additive) {
      navigatorKey.currentState!.push(wrappedRoute);
    } else {
      navigatorKey.currentState!.pushReplacement(wrappedRoute);
    }
  }

  static void navigateOverlayPage(Route route) {
    // Route wrappedRoute;
    // wrappedRoute = route; // Keep the original route if no header/navbar is required

    navigatorKey.currentState!.push(route);
  }

  static void pop() {
    navigatorKey.currentState!.pop();
  }
}
