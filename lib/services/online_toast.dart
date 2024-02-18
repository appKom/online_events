import 'package:flutter/material.dart';
import 'package:online/components/icon_label.dart';
import 'package:online/theme/themed_icon.dart';
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
  static ({Color fill, Color border, Color text}) colorsFromType(ToastType type) {
    switch (type) {
      case ToastType.neutral:
        return (
          border: OnlineTheme.grayBorder,
          fill: OnlineTheme.background,
          text: OnlineTheme.white,
        );
      case ToastType.green:
        return (
          border: OnlineTheme.green,
          fill: OnlineTheme.green.darken(50),
          text: OnlineTheme.green,
        );
      case ToastType.yellow:
        return (
          border: OnlineTheme.yellow,
          fill: OnlineTheme.yellow.darken(50),
          text: OnlineTheme.yellow,
        );
      case ToastType.red:
        return (
          border: OnlineTheme.red,
          fill: OnlineTheme.red.darken(50),
          text: OnlineTheme.yellow,
        );
    }
  }

  static void show(
    IconType icon,
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
          height: OnlineTheme.buttonHeight,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: colors.fill,
            border: Border.fromBorderSide(BorderSide(color: colors.border, width: 2)),
            borderRadius: OnlineTheme.buttonRadius,
            boxShadow: [
              BoxShadow(
                color: OnlineTheme.background.withOpacity(0.25),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: IconLabel(
            icon: icon,
            label: message,
            color: colors.text,
            iconSize: 18,
          ),
        ),
      ),
    );
  }
}
