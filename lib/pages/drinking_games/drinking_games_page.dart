import 'package:flutter/material.dart';
import 'package:online_events/pages/drinking_games/bytes/bytes_home_page.dart';
import 'package:online_events/pages/drinking_games/spin_line.dart';
import 'package:online_events/pages/drinking_games/spin_line_page.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'bits/bits_home_page.dart';
import 'dice.dart';
import 'songs/songs.dart';

class DrinkingGamesPage extends ScrollablePage {
  const DrinkingGamesPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: OnlineHeader.height(context) + 5),
            const DrikkeSanger(),
            const SizedBox(height: 25),
            const Text(
              'Drikkeleker',
              style: OnlineTheme.eventHeader,
            ),
            const SizedBox(height: 24),
            GameCard(
                name: 'Terning',
                imageSource: 'assets/images/diceHeader.jpg',
                onTap: () {
                  PageNavigator.navigateTo(const DicePage());
                }),
            const SizedBox(height: 24),
            GameCard(
                name: 'SpinLine',
                imageSource: 'assets/images/SpinLine.png',
                onTap: () {
                  PageNavigator.navigateTo(SpinLinePage());
                }),
            const SizedBox(
              height: 24,
            ),
            GameCard(
              name: 'Bits',
              imageSource: 'assets/images/bits.png',
              onTap: () {
                PageNavigator.navigateTo(const BitsHomePage());
              },
            ),
            const SizedBox(height: 24),
            GameCard(
              name: 'Bytes',
              imageSource: 'assets/images/bytes.png',
              onTap: () {
                PageNavigator.navigateTo(const BytesHomePage());
              },
            ),
            SizedBox(height: Navbar.height(context) + 24),
          ],
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

class GameCard extends StatelessWidget {
  final String name;
  final String imageSource;

  final void Function() onTap;

  const GameCard({
    super.key,
    required this.name,
    required this.imageSource,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: onTap,
      childBuilder: (context, hover, pointerDown) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: double.infinity, // as wide as the parent allows
            height: 222, // fixed height
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    imageSource,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(
                        12), // Add some padding around the text
                    color: Colors.black.withOpacity(
                        0.5), // Semi-transparent background for the text
                    child: Text(
                      name,
                      style: OnlineTheme.textStyle(weight: 7, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
