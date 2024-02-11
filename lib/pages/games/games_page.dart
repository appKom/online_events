import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/pages/games/spin_line_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'bits/bits_home_page.dart';
import 'dice.dart';
import 'songs/songs.dart';

class GamesPage extends ScrollablePage {
  const GamesPage({super.key});

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: DrikkeSanger(),
            ),
            const SizedBox(height: 24),
            Text(
              'Spill',
              style: OnlineTheme.header(),
            ),
            const SizedBox(height: 10),
            CarouselSlider(
              items: [
                GameCard(
                  name: 'Terning',
                  imageSource: 'assets/images/diceHeader.jpg',
                  onTap: () {
                    AppNavigator.navigateToPage(const DicePage());
                  },
                ),
                GameCard(
                  name: 'SpinLine',
                  imageSource: 'assets/images/SpinLine.png',
                  onTap: () {
                    AppNavigator.navigateToPage(const SpinLinePage());
                  },
                ),
                GameCard(
                  name: 'Bits',
                  imageSource: 'assets/images/bits.png',
                  onTap: () {
                    AppNavigator.navigateToPage(const BitsHomePage());
                  },
                ),
              ],
              options: CarouselOptions(
                enableInfiniteScroll: true,
                padEnds: true,
                enlargeCenterPage: true,
              ),
            ),
          ],
        ),
      ),
    );
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
            width: double.infinity,
            height: 222,
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
                    padding: const EdgeInsets.all(12),
                    color: Colors.black.withOpacity(0.5),
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
