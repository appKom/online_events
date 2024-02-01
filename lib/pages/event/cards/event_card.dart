import 'package:flutter/material.dart';

import '/theme/theme.dart';

class OnlineCard extends StatelessWidget {
  final Widget child;

  const OnlineCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: OnlineTheme.background.lighten(20),
        border: Border.all(color: OnlineTheme.grayBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
