import 'package:flutter/material.dart';

class ThemeConfig {
  /// Background
  final Color bg;

  // Foreground
  final Color fg;

  final Color muted;
  final Color mutedForeground;

  final Color popoverBarrier;
  final Color popover;
  final Color popoverFg;

  final Color card;
  final Color cardFg;

  final Color border;

  final Color primary;
  final Color primaryBg;
  final Color primaryFg;

  /// Positive
  final Color pos;

  /// Positive background
  final Color posBg;

  /// Positive foreground
  final Color posFg;

  final Color wait;
  final Color waitBg;
  final Color waitFg;

  /// Negative
  final Color neg;

  /// Negative background
  final Color negBg;

  /// Negative foreground
  final Color negFg;

  ThemeConfig({
    required this.bg,
    required this.fg,
    required this.muted,
    required this.mutedForeground,
    required this.popover,
    required this.popoverFg,
    required this.card,
    required this.cardFg,
    required this.popoverBarrier,
    required this.border,
    required this.primary,
    required this.primaryBg,
    required this.primaryFg,
    required this.pos,
    required this.posBg,
    required this.posFg,
    required this.wait,
    required this.waitBg,
    required this.waitFg,
    required this.neg,
    required this.negBg,
    required this.negFg,
  });
}

final darkTheme = ThemeConfig(
  bg: const Color.fromRGBO(18, 18, 18, 1),
  fg: const Color.fromRGBO(250, 250, 250, 1),
  muted: const Color.fromRGBO(25, 25, 25, 1),
  mutedForeground: const Color.fromRGBO(163, 163, 163, 1),
  popoverBarrier: const Color.fromRGBO(5, 5, 5, 0.8),
  popover: const Color.fromRGBO(20, 20, 20, 0.9),
  popoverFg: const Color.fromRGBO(250, 250, 250, 1),
  card: const Color.fromRGBO(15, 15, 15, 1),
  cardFg: const Color.fromRGBO(250, 250, 250, 1),
  border: const Color.fromRGBO(38, 38, 38, 1),
  primary: const Color.fromRGBO(250, 183, 89, 1),
  primaryBg: const Color.fromRGBO(254, 185, 47, 1).darken(50),
  primaryFg: const Color.fromRGBO(250, 183, 89, 1),
  wait: const Color.fromRGBO(250, 183, 89, 1),
  waitBg: const Color.fromRGBO(254, 185, 47, 1).darken(50),
  waitFg: const Color.fromRGBO(250, 183, 89, 1),
  pos: const Color.fromRGBO(50, 200, 80, 1),
  posBg: const Color.fromRGBO(50, 200, 80, 1).darken(60),
  posFg: const Color.fromRGBO(50, 200, 80, 1),
  neg: const Color.fromRGBO(220, 50, 80, 1),
  negBg: const Color.fromRGBO(220, 50, 80, 1).darken(60),
  negFg: const Color.fromRGBO(220, 50, 80, 1),
);

sealed class OnlineTheme {
  static final current = darkTheme;

  static const blueBg = Color(0xFF0D2546);
  static const blue2 = Color.fromARGB(255, 119, 178, 255);

  static const purple1 = Color(0xFFAB18C8);

  static const gray0 = Color(0xFF22272F);
  static const gray8 = Color(0xFFA6ABB5);
  static const gray9 = Color(0xFFB7BBC3);
  static const gray15 = Color(0xFF4C566A); // Only used once by skeleton loader
  static const gray16 = Color(0xFF797979); // Only used once by skeleton loader

  static const hundredPrimaryTextColor = Color(0xFF414C6B);
  static const hundredSecondaryTextColor = Color(0xFFE4979E);
  static const hundredTitleTextColor = Colors.white;
  static const hundredContentTextColor = Color(0xff868686);
  static const hundredNavigationColor = Color(0xFF6751B5);
  static const hundredGradientStartColor = Color(0xFF4051A9);
  static const hundredGradientEndColor = Color(0xFF9354B9);
  static const hundredDotColor = Color(0xFFA87DCF);

  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 20);

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 500;
  }

  static const purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.purple, // Start color
      Colors.deepPurple, // End color
    ],
  );

  static const yellowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromARGB(255, 255, 132, 0), // Start color
      Color.fromARGB(255, 122, 118, 0), // End color
    ],
  );

  static final greenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.green[300]!,
      Colors.green[800]!,
    ],
  );

  static const blueGradient = LinearGradient(
    colors: [
      OnlineTheme.blue2,
      OnlineTheme.blueBg,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static final redGradient = LinearGradient(
    colors: [
      const Color.fromARGB(255, 245, 98, 98),
      Colors.red[800]!,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Fonts
  static const font = 'Poppins';

  static const buttonHeight = 40.0;
  static const buttonRadius = BorderRadius.all(Radius.circular(5));

  static FontWeight _translateWeight(int weight) {
    switch (weight) {
      case == 9:
        return FontWeight.w900;
      case == 8:
        return FontWeight.w800;
      case == 7:
        return FontWeight.w700;
      case == 6:
        return FontWeight.w600;
      case == 5:
        return FontWeight.w500;
      case == 4:
        return FontWeight.w400;
      case == 3:
        return FontWeight.w300;
      case == 2:
        return FontWeight.w200;
      case == 1:
        return FontWeight.w100;
      default:
        throw Exception('Font weight must be in the range 1-9.');
    }
  }

  static TextStyle header() => textStyle(size: 20, weight: 6);
  static TextStyle subHeader([Color? color]) => textStyle(
        size: 16,
        weight: 6,
        color: color ?? current.fg,
      );

  static TextStyle textStyle({
    Color? color,
    int weight = 4,
    double size = 16,
    double height = 1.5,
  }) {
    return TextStyle(
      fontFamily: font,
      color: color ?? current.fg,
      fontWeight: _translateWeight(weight),
      fontSize: size,
      height: height,
      fontStyle: FontStyle.normal,
      decoration: TextDecoration.none,
    );
  }
}

extension ColorEffects on Color {
  Color lighten(double pct) {
    pct = (pct / 100) + 1;

    int r = (red * pct).toInt().clamp(0, 255);
    int g = (green * pct).toInt().clamp(0, 255);
    int b = (blue * pct).toInt().clamp(0, 255);

    return Color.fromARGB(alpha, r, g, b);
  }

  Color darken(double pct) {
    pct = 1 - (pct / 100);

    int r = (red * pct).toInt().clamp(0, 255);
    int g = (green * pct).toInt().clamp(0, 255);
    int b = (blue * pct).toInt().clamp(0, 255);

    return Color.fromARGB(alpha, r, g, b);
  }
}
