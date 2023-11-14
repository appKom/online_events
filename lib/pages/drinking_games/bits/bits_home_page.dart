import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/pages/drinking_games/bits/sub_pages/bits_page_one.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';

class BitsHomePage extends ScrollablePage {
  const BitsHomePage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Container(
      color: OnlineTheme.pink1,
      child: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: OnlineHeader.height(context) + 40),
              const Text(
                'Velkommen til Bits <3',
                style: OnlineTheme.eventHeader,
              ),
              const SizedBox(height: 20),
              const Text(
                'Bits er en kombinasjon av de beste aspektene av ulike drikkeleker. Det er bare å hente deg en ny enhet, for den du holder nå kommer til å bli tømt ganske snabt. ',
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
                        PageNavigator.navigateTo(const BitsPageOne());
                      },
                      childBuilder: (context, hover, pointerDown) {
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: OnlineTheme.green4,
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
