import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/core/client/client.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

class GameOverPage extends StatelessWidget {
  const GameOverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    final theme = OnlineTheme.current;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [OnlineTheme.purple1, Color.fromARGB(255, 225, 10, 189)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.9],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: MediaQuery.of(context).padding,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(children: [
                  const SizedBox(width: 10),
                  AnimatedButton(onTap: () {
                    AppNavigator.pop();
                  }, childBuilder: (context, hover, pointerDown) {
                    return Icon(
                      Icons.close_outlined,
                      color: OnlineTheme.current.fg,
                      size: 30,
                    );
                  }),
                  const Spacer(),
                ]),
                Text(
                  'Game Over',
                  style: OnlineTheme.textStyle(size: 32, weight: 5),
                ),
                Text(
                  'Da var spillet over :(',
                  style: OnlineTheme.textStyle(),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AnimatedButton(
                        onTap: () {
                          AppNavigator.pop();
                        },
                        childBuilder: (context, hover, pointerDown) {
                          return Padding(
                            padding: EdgeInsets.only(left: padding.left, right: padding.right),
                            child: Container(
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 248, 98, 6).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.fromBorderSide(BorderSide(color: theme.fg, width: 2)),
                              ),
                              child: Text(
                                'Tilbake',
                                style: OnlineTheme.textStyle(
                                  weight: 5,
                                  color: theme.fg,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AnimatedButton(
                        onTap: () {
                          Client.launchInBrowser('https://forms.gle/xUTTN95CuWtSbNCS7');
                        },
                        childBuilder: (context, hover, pointerDown) {
                          return Padding(
                            padding: EdgeInsets.only(left: padding.left, right: padding.right),
                            child: Container(
                              height: OnlineTheme.buttonHeight,
                              decoration: BoxDecoration(
                                color: theme.posBg,
                                borderRadius: OnlineTheme.buttonRadius,
                                border: Border.fromBorderSide(
                                  BorderSide(color: theme.pos, width: 2),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Gi tilbakemelding!',
                                  style: OnlineTheme.textStyle(weight: 5, color: theme.posFg),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
