import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class CardBadge extends StatelessWidget {
  final Color border;
  final Color fill;
  final String text;

  const CardBadge({
    super.key,
    required this.border,
    required this.fill,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    const height = 24.0;
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: height / 2),
      decoration: BoxDecoration(
        color: fill,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Center(
        child: Text(
          text,
          style: OnlineTheme.textStyle(size: 14, height: 1),
        ),
      ),
    );
  }
}
