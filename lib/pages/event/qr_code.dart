import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/components/animated_button.dart';
import '/dark_overlay.dart';
import '/theme/theme.dart';

class QRCode extends DarkOverlay {
  final String name;

  QRCode({required this.name});

  @override
  Widget content(BuildContext context, Animation<double> animation) {
    final padding = MediaQuery.of(context).padding;

    return LayoutBuilder(builder: (context, constraints) {
      final maxSize = min(constraints.maxWidth, constraints.maxHeight);

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: OnlineTheme.textStyle(size: 25, weight: 7),
          ),
          const SizedBox(height: 40),
          SizedBox.square(
            dimension: maxSize - padding.horizontal - 50,
            child: AnimatedButton(
              childBuilder: (context, hover, pointerDown) {
                return SvgPicture.asset(
                  'assets/svg/qr_code.svg',
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
