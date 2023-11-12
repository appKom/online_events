import 'package:flutter/material.dart';

sealed class OnlineTheme {
  // Colors
  static const background = Color(0xFF000212); // ARGB
  static const white = Color(0xFFFFFFFF);

  static const blue1 = Color(0xFF0D2546);
  static const blue2 = Color.fromARGB(255, 119, 178, 255);
  static const blue3 = Color(0xFF0D2546);

  static const green1 = Color.fromARGB(255, 37, 208, 171);
  static const green2 = Color.fromARGB(255, 4, 49, 44);
  static const green3 = Color(0xFF83AF89);
  static const green4 = Color(0xFF1E3822);

  static const red1 = Color(0xFFF43145);

  static const pink1 = Color(0xFF5E0231);

  static const yellow = Color(0xFFFAB759);
  static const orange10 = Color(0xFFFFEDB3); // More like yellow10

  static const gray0 = Color(0xFF22272F);
  static const gray8 = Color(0xFFA6ABB5);
  static const gray9 = Color(0xFFB7BBC3);
  static const gray10 = Color(0xFFC9CCD2);
  static const gray11 = Color(0xFFDBDDE1);
  static const gray12 = Color(0xFFEDEEF0);
  static const gray13 = Color(0xFF131315);
  static const gray14 = Color(0xFF22272F);
  static const gray15 = Color(0xFF4C566A);

  // Fonts
  static const font = 'Poppins';

  static const eventListHeader = TextStyle(
    fontFamily: font,
    color: gray11,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  // static const eventBedpressHeader = TextStyle(
  //   fontFamily: font,
  //   color: gray11,
  //   fontWeight: FontWeight.w400,
  //   fontSize: 16,
  //   height: 1.5,
  //   fontStyle: FontStyle.normal,
  //   decoration: TextDecoration.none,
  // );

  static const eventHeader = TextStyle(
    fontFamily: font,
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const loginPageEmail = TextStyle(
    fontFamily: font,
    color: white,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const logInnPageInput = TextStyle(
    fontFamily: font,
    color: gray15,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const logInnPageButton = TextStyle(
    fontFamily: font,
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const goToButton = TextStyle(
    fontFamily: font,
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

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
        throw Exception('Unsupported fontWeight. Must be in the range 1-9.');
    }
  }

  static textStyle({
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
