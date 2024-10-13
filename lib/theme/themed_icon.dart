import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'theme.dart';

enum IconType {
  bell,
  bellSlash,
  badgeCheck,
  dateTime,
  clock,
  location,
  camScan,
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
  pixel,
  pixelFilled,
  script,
  users,
  usersFilled,
  user,
  userFilled,
  userEdit,
  education,
  dices,
  dicesFilled,
  cross,
  menu,
  menuFilled,
  trash,
  download,
  downArrow,
}

class ThemedIcon extends StatelessWidget {
  ThemedIcon({
    super.key,
    required this.icon,
    required this.size,
    Color? color,
  }) : color = color ?? OnlineTheme.current.fg;

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

enum LucideIcon {
  trash,
  download,
  settings,
  user,
  users,
  notebook,
  bug,
  database,
  notification,
}

class Lucide extends StatelessWidget {
  Lucide(
    this.icon, {
    super.key,
    required this.size,
    Color? color,
  }) : color = color ?? OnlineTheme.current.fg;

  final LucideIcon icon;
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
    final path = 'assets/icons/lucide/$icon.svg';
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
