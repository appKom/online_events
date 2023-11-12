import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/separator.dart';

import '/components/animated_button.dart';
import '/dark_overlay.dart';
import '/theme/theme.dart';

class ShowParticipants extends DarkOverlay {
  @override
  Widget content(BuildContext context, Animation<double> animation) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 25);

    return LayoutBuilder(builder: (context, constraints) {
      final maxSize = min(constraints.maxWidth, constraints.maxHeight);

      return Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Påmeldte',
            style: OnlineTheme.textStyle(size: 25, weight: 7),
          ),
          const SizedBox(height: 40),
          const Separator(margin: 5),
          Row(
            children: [
              Padding(
                padding: horizontalPadding,
                child: Text(
                  '1. ',
                  style: OnlineTheme.textStyle(),
                ),
              ),
              Padding(
                padding: horizontalPadding,
                child: Text(
                  'Fredrik Hansteen',
                  style: OnlineTheme.textStyle(),
                ),
              ),
              const Spacer(), // This will push the next Text widget to the right
              Padding(
                padding: const EdgeInsets.only(right: 50), // Adjust right padding if needed
                child: Text(
                  '5. klasse',
                  style: OnlineTheme.textStyle(),
                ),
              ),
            ],
          ),
          const Separator(margin: 5),
          Row(
            children: [
              Padding(
                padding: horizontalPadding,
                child: Text(
                  '2. ',
                  style: OnlineTheme.textStyle(),
                ),
              ),
              Padding(
                padding: horizontalPadding,
                child: Text(
                  'Erlend Strøm',
                  style: OnlineTheme.textStyle(),
                ),
              ),
              const Spacer(), // This will push the next Text widget to the right
              Padding(
                padding: const EdgeInsets.only(right: 50), // Adjust right padding if needed
                child: Text(
                  '1. klasse',
                  style: OnlineTheme.textStyle(),
                ),
              ),
            ],
          ),
          const Separator(margin: 5),
        ],
      );
    });
  }
}
