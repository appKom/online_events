import 'package:flutter/material.dart';

sealed class OnlineTheme {
  // Colors
  static const background = Color(0xFF050505);
  static const white = Color(0xFFFFFFFF);

  static const blue1 = Color(0xFF0D2546);
  static const blue2 = Color.fromARGB(255, 119, 178, 255);
  static const blue3 = Color(0xFF0D2546);
  static const blue4 = Color(0xFF0047AB);
  static const onlineBlue = Color(0xFF0B5374);

  static const green = Color.fromRGBO(50, 200, 80, 1);

  static const green1 = Color.fromARGB(255, 37, 208, 171);
  static const green2 = Color.fromARGB(255, 4, 49, 44);
  static const green3 = Color(0xFF83AF89);
  static const green4 = Color(0xFF1E3822);
  static const green5 = Color(0xFF09AA09);

  static const red = Color.fromRGBO(220, 50, 80, 1);
  static const red1 = Color(0xFFF43145);

  static const yellow = Color(0xFFFAB759);

  static const purple1 = Color(0xFFAB18C8);

  static const lightGray = Color(0xFFD0D0D0);
  static const darkGray = Color(0xFF151520);

  static const gray0 = Color(0xFF22272F);
  static const gray8 = Color(0xFFA6ABB5);
  static const gray9 = Color(0xFFB7BBC3);
  static const gray15 = Color(0xFF4C566A); // Only used once by skeleton loader
  static const gray16 = Color(0xFF797979); // Only used once by skeleton loader

  static const grayBorder = Color(0xFF22272F);

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
      OnlineTheme.blue4,
    ], // Blue gradient for "Se Påmeldte"
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
  static TextStyle subHeader([Color? color]) =>
      textStyle(size: 16, weight: 6, color: color ?? white);

  static TextStyle textStyle({
    Color color = white,
    int weight = 4,
    double size = 16,
    double height = 1.5,
  }) {
    return TextStyle(
      fontFamily: font,
      color: color,
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
