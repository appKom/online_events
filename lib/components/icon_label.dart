import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../theme/themed_icon.dart';

class IconLabel extends StatelessWidget {
  final IconType icon;
  final String label;
  final Color color;
  final double fontSize;
  final int fontWeight;
  final double iconSize;

  final MainAxisAlignment alignment;

  const IconLabel({
    super.key,
    required this.icon,
    required this.label,
    this.color = OnlineTheme.white,
    this.fontSize = 16,
    this.iconSize = 20,
    this.fontWeight = 4,
    this.alignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: alignment,
      children: [
        ThemedIcon(icon: icon, size: iconSize, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: OnlineTheme.textStyle(color: color, size: fontSize, weight: fontWeight),
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}
