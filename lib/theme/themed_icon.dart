import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'theme.dart';

enum IconType {
  dateTime,
  location,
  people,
  copy,
  calendarClock,
  calendarClockFilled,
  settings,
  settingsFilled,
  home,
  homeFilled,
  beer,
  beerFilled,
  qr,
}

class ThemedIcon extends StatelessWidget {
  const ThemedIcon({
    super.key,
    required this.icon,
    required this.size,
    this.color = OnlineTheme.white,
  });

  final IconType icon;
  final Color color;

  final double size;

  String _iconName() {
    String camel = icon.toString().split('.').last;

    final buffer = StringBuffer();

    for (int i = 0; i < camel.length; i++) {
      final char = camel[i];

      if (char.toUpperCase() == char) {
        buffer.write('_${char.toLowerCase()}');
      } else {
        buffer.write(char);
      }
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    String icon = _iconName();
    final path = 'assets/icons/$icon.svg';
    return SvgPicture.asset(
      path,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }
}
