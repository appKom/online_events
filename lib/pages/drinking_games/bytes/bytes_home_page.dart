import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/theme/theme.dart';

class BytesHomePage extends ScrollablePage {
  const BytesHomePage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Container(
      color: OnlineTheme.green4,
      child: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: OnlineHeader.height(context) + 40),
              const Text(
                'Velkommen til Bytes <3',
                style: OnlineTheme.eventHeader,
              ),
              const SizedBox(height: 20),
              const Text(
                'Get ready to rumble',
                style: OnlineTheme.eventListHeader,
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
                            color: OnlineTheme.red1,
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
