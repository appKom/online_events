import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:online_events/components/separator.dart';
import '/pages/drinking_games/bits/bits_page.dart';

import '/components/animated_button.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
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

    const background = Color.fromARGB(255, 225, 10, 189);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            OnlineTheme.background,
            background,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: OnlineHeader.height(context) + 40),
              Text(
                'Velkommen til Bits <3',
                style: OnlineTheme.textStyle(size: 20, weight: 7),
              ),
              const SizedBox(height: 20),
              Text(
                'Bits er en kombinasjon av de beste aspektene av ulike drikkeleker. Det er bare å hente deg en ny enhet, for den du holder nå kommer til å bli tømt ganske snabt. ',
                style: OnlineTheme.textStyle(),
              ),
              const SizedBox(height: 15,),
              Text('Trykk på sidene av skjermen for å komme deg videre', style: OnlineTheme.textStyle(),),
              const SizedBox(height: 120),
              AnimatedButton(
                onTap: () {
                  PageNavigator.navigateTo(const BitsGame());
                },
                childBuilder: (context, hover, pointerDown) {
                  return Container(
                    height: OnlineTheme.buttonHeight,
                    decoration: const BoxDecoration(
                      gradient: OnlineTheme.purpleGradient,
                      borderRadius: OnlineTheme.buttonRadius,
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
