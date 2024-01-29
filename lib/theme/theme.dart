import 'package:flutter/material.dart';

sealed class OnlineTheme {
  // Colors
  static const background = Color(0xFF000212); // ARGB
  static const white = Color(0xFFFFFFFF);

  static const blue1 = Color(0xFF0D2546);
  static const blue2 = Color.fromARGB(255, 119, 178, 255);
  static const blue3 = Color(0xFF0D2546);
  static const blue4 = Color(0xFF0047AB);
  static const onlineBlue = Color(0xFF0B5374);

  static const green1 = Color.fromARGB(255, 37, 208, 171);
  static const green2 = Color.fromARGB(255, 4, 49, 44);
  static const green3 = Color(0xFF83AF89);
  static const green4 = Color(0xFF1E3822);
  static const green5 = Color(0xFF09AA09);

  static const red1 = Color(0xFFF43145);

  static const pink1 = Color(0xFF5E0231);
  static const pink2 = Color(0xFFEB536E);

  static const yellow = Color(0xFFFAB759);

  static const purple1 = Color(0xFFAB18C8);

  static const gray0 = Color(0xFF22272F);
  static const gray8 = Color(0xFFA6ABB5);
  static const gray9 = Color(0xFFB7BBC3);
  static const gray10 = Color(0xFFC9CCD2);
  static const gray11 = Color(0xFFDBDDE1);
  static const gray12 = Color(0xFFEDEEF0);
  static const gray13 = Color(0xFF131315);
  static const gray14 = Color(0xFF22272F);
  static const gray15 = Color(0xFF4C566A);
  static const gray16 = Color(0xFF797979);

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
  static const eventButtonRadius = BorderRadius.all(Radius.circular(10));

  @Deprecated('Use OnlineTheme.textStyle() instead.')
  static const eventListHeader = TextStyle(
    fontFamily: font,
    color: gray11,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.5,
    fontStyle: FontStyle.normal,
    decoration: TextDecoration.none,
  );

  @Deprecated('Use OnlineTheme.textStyle() instead.')
  static const eventHeader = TextStyle(
    fontFamily: font,
    color: white,
    fontWeight: FontWeight.w700,
    fontSize: 24,
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

  static TextStyle header() => textStyle(size: 20, weight: 7);
  static TextStyle subHeader() => textStyle(size: 15, weight: 5);

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
