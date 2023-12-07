import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({super.key, this.margin = 0});

  final double margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: margin),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF000212),
            Color(0xFF2E3440),
            Color(0xFF000212),
          ],
        ),
      ),
    );
  }
}
