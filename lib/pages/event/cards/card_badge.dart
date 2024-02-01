import 'package:flutter/material.dart';
import '/theme/theme.dart';

class CardBadge extends StatelessWidget {
  final Color fill;
  final Color border;
  // final Gradient gradient; // Changed from Color to Gradient
  final String text;

  const CardBadge({
    super.key,
    required this.fill,
    required this.border,
    // required this.gradient, // Changed parameter
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    const height = 30.0;

    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: height / 2),
      decoration: BoxDecoration(
        // gradient: gradient, // Use gradient here
        color: fill,
        border: Border.all(color: border, width: 2),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Center(
        child: Text(
          text,
          style: OnlineTheme.textStyle(size: 14, height: 1, color: border, weight: 5),
        ),
      ),
    );
  }
}
