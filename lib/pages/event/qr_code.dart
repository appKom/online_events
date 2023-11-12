import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/dark_overlay.dart';

class QRCode extends DarkOverlay {
  @override
  Widget content(BuildContext context, Animation<double> animation) {
    final padding = MediaQuery.of(context).padding;

    return LayoutBuilder(builder: (context, constraints) {
      final maxSize = min(constraints.maxWidth, constraints.maxHeight);

      return SizedBox.square(
        dimension: maxSize - padding.horizontal - 50,
        child: AnimatedButton(
          child: SvgPicture.asset(
            'assets/svg/qr_code.svg',
          ),
        ),
      );
    });
  }
}
