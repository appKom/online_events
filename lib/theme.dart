import 'package:flutter/material.dart';

sealed class OnlineTheme {
  // Colors
  static const background = Color(0xFF000212); // ARGB
  static const white = Color(0xFFFFFFFF);

  static const gray11 = Color(0xFFDBDDE1);
  static const gray9 = Color(0xFFB7BBC3);
  static const gray12 = Color(0xFFEDEEF0);

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

  static const eventListSubHeader = TextStyle(
    fontFamily: font,
    color: gray9,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );
}
