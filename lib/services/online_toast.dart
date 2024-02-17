import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../theme/theme.dart';
import 'app_navigator.dart';

enum ToastType {
  neutral,
  green,
  yellow,
  red,
}

abstract class OnlineToast {
  static ({Color fill, Color border}) colorsFromType(ToastType type) {
    switch (type) {
      case ToastType.neutral:
        return (border: OnlineTheme.grayBorder, fill: OnlineTheme.background.withOpacity(0.8));
      case ToastType.green:
        return (border: OnlineTheme.green, fill: OnlineTheme.green.darken(50).withOpacity(0.8));
      case ToastType.yellow:
        return (border: OnlineTheme.yellow, fill: OnlineTheme.yellow.darken(50).withOpacity(0.8));
      case ToastType.red:
        return (border: OnlineTheme.red, fill: OnlineTheme.red.darken(50).withOpacity(0.8));
    }
  }

  static void show(
    String message, {
    Duration duration = const Duration(seconds: 3),
    ToastType type = ToastType.neutral,
  }) {
    final context = AppNavigator.globalNavigator.currentContext;

    if (context == null) throw Exception('No context!');

    final query = MediaQuery.of(context);

    final colors = colorsFromType(type);

    showOverlayNotification(
      duration: duration,
      (context) => Container(
        margin: query.padding + OnlineTheme.horizontalPadding,
        child: Container(
          height: 36,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: OnlineTheme.background.withOpacity(0.25),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ]),
          child: Container(
            decoration: BoxDecoration(
              color: colors.fill,
              border: Border.fromBorderSide(BorderSide(color: colors.border, width: 2)),
              borderRadius: OnlineTheme.buttonRadius,
            ),
            child: Center(
              child: Text(
                message,
                style: OnlineTheme.textStyle(weight: 5, color: colors.border),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
