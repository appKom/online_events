import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/theme/theme.dart';

class BytesHomePage extends ScrollablePage {
  const BytesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Container(
      color: OnlineTheme.current.pos,
      child: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Velkommen til Bytes <3',
                style: OnlineTheme.header(),
              ),
              const SizedBox(height: 20),
              Text(
                'Get ready to rumble',
                style: OnlineTheme.header(),
              ),
              const ClipRRect(child: SizedBox(height: 120)),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: AnimatedButton(
                      onTap: () {
                        // TODO:
                      },
                      childBuilder: (context, hover, pointerDown) {
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: OnlineTheme.current.neg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Start spillet!',
                              style: OnlineTheme.textStyle(),
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
      ),
    );
  }

  @override
  Widget content(BuildContext context) {
    // Properly implement the content method or make sure it's not called if not needed.
    return Container(); // Return an empty Container or actual content if available
  }
}
