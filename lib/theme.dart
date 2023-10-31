import 'package:flutter/material.dart';

sealed class OnlineTheme {
  // Colors
  static const background = Color(0xFF000212); // ARGB
  static const white = Color(0xFFFFFFFF);

  static const blue1 = Color(0xFF0D2546);
  static const blue2 = Color.fromARGB(255, 119, 178, 255);

  static const green1 = Color.fromARGB(255, 37, 208, 171);
  static const green2 = Color.fromARGB(255, 4, 49, 44);
  static const green3 = Color(0xFF83AF89);

  static const red1 = Color(0xFFF43145);

  static const yellow = Color(0xFFFAB759);
  static const orange10 = Color(0xFFFFEDB3); // More like yellow10

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

  static const eventBedpressHeader = TextStyle(
    fontFamily: font,
    color: gray11,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const eventListSubHeader = TextStyle(
    fontFamily: font,
    color: gray9,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const eventHeader = TextStyle(
    fontFamily: font,
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const eventCardDate = TextStyle(
    fontFamily: font,
    color: yellow,
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const eventDateNumber = TextStyle(
    fontFamily: font,
    color: yellow,
    fontWeight: FontWeight.w700,
    fontSize: 25,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const eventDateMonth = TextStyle(
    fontFamily: font,
    color: yellow,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const eventNumberOfPeople = TextStyle(
    fontFamily: font,
    color: yellow,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const promotedArticleText = TextStyle(
    fontFamily: font,
    color: yellow,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const promotedArticleAuthor = TextStyle(
    fontFamily: font,
    color: white,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const promotedArticleDate = TextStyle(
    fontFamily: font,
    color: yellow,
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const logInnPageHeader = TextStyle(
    fontFamily: font,
    color: white,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  static const logInnPageEmail = TextStyle(
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
