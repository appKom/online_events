import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/pages/event/cards/event_card_buttons.dart';
import 'package:online_events/services/app_navigator.dart';

import '/components/animated_button.dart';
import '/dark_overlay.dart';
import '/theme/theme.dart';

class ConfirmRegistration extends DarkOverlay {

  final VoidCallback onConfirm;

  ConfirmRegistration({required this.onConfirm});

  @override
  Widget content(BuildContext context, Animation<double> animation) {
    final padding = MediaQuery.of(context).padding;

    return LayoutBuilder(builder: (context, constraints) {
      final maxSize = min(constraints.maxWidth, constraints.maxHeight);

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bekreft Påmelding',
            style: OnlineTheme.textStyle(size: 25, weight: 7),
          ),
          const SizedBox(height: 40),
          Row(
            children:[

            const Spacer(),
            SizedBox(
            height: 200,
            width: 200,
            child: AnimatedButton(
              onTap: () {
                setState(() {
                  isRegistered = !isRegistered; 
                  navigator?.pop(context);
                }
                );
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  alignment: Alignment.center,
                  height: 50,
                 decoration: BoxDecoration(
                        gradient: OnlineTheme.greenGradient,
                        borderRadius: BorderRadius.circular(5),
                      ),
                  child: Text('Bekreft', style: OnlineTheme.textStyle()),
                );
              },
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 200,
            width: 200,
            child: AnimatedButton(
              onTap: () {
                setState(() {
                  navigator?.pop(context);
                }
                );
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  alignment: Alignment.center,
                  height: 50,
                 decoration: BoxDecoration(
                        gradient: OnlineTheme.redGradient,
                        borderRadius: BorderRadius.circular(5),
                      ),
                  child: Text('Ikke bekreft', style: OnlineTheme.textStyle()),
                );
              },
            ),
          ),
          const Spacer()
            ],
          ),

        ],
      );
    });
  }
}
