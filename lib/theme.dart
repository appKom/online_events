import 'package:flutter/material.dart';

sealed class OnlineTheme {
  // static const blue = Color.fromRGBO(13, 83, 116, 1);
  // static const white = Color.fromRGBO(255, 255, 255, 1);
  // static const black = Color.fromRGBO(0, 0, 0, 1);
  // static const gray = Color.fromRGBO(204, 204, 204, 1);
  // static const orange = Color.fromRGBO(255, 165, 0, 1);
  // static const yellow = Color.fromRGBO(253, 189, 71, 1);
  // static const green = Color.fromRGBO(67, 177, 113, 1);
  // static const red = Color.fromRGBO(235, 83, 110, 1);
  // static const purple = Color.fromRGBO(179, 107, 205, 1);
  // static const lightBlue = Color.fromRGBO(42, 198, 249, 1);

  // Colors
  static const background = Color(0xFF000212); // ARGB

  static const gray11 = Color(0xFFDBDDE1);
  static const gray9 = Color(0xFFB7BBC3);

  // Fonts
  static const font = 'Poppins';

  static const eventListHeader = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24,
  );

  static const eventListSubHeader = TextStyle(
    fontFamily: font,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 18,
  );
}
