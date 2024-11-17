import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/theme/theme.dart';
import 'songs/songs.dart';

class GamesPage extends ScrollablePage {
  const GamesPage({super.key});

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    return ClipRect(
      child: Container(
        color: OnlineTheme.current.bg,
        padding: padding + EdgeInsets.symmetric(vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            DrikkeSanger(carouselOptions: getCarouselOptions(context)),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            Text(
              'Spill',
              style: OnlineTheme.header(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CarouselSlider(
              items: [
                GameCard(
                  name: 'Terning',
                  imageSource: 'assets/images/diceHeader.jpg',
                  onTap: () {
                    context.go('/social/dice');
                  },
                ),
                GameCard(
                  name: 'Hundre spørsmål',
                  imageSource: 'assets/images/hundred-questions.png',
                  onTap: () {
                    context.go('/social/hundred_questions');
                  },
                ),
                GameCard(
                  name: 'SpinLine',
                  imageSource: 'assets/images/SpinLine.png',
                  onTap: () {
                    context.go('/social/spinline');
                  },
                ),
                GameCard(
                  name: 'Roulette',
                  imageSource: 'assets/images/roulette.png',
                  onTap: () {
                    context.go('/social/roulette');
                    // AppNavigator.navigateToPage(const RoulettePage(), withHeaderNavbar: false);
                  },
                ),
                GameCard(
                  name: 'Bits',
                  imageSource: 'assets/images/bits.png',
                  onTap: () {
                    context.go('/social/bits');
                    // AppNavigator.navigateToPage(const BitsHomePage(), withHeaderNavbar: false);
                  },
                ),
              ],
              options: getCarouselOptions(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static getCarouselOptions(BuildContext context) {
    final isMobile = OnlineTheme.isMobile(context);

    return CarouselOptions(
      height: 200,
      enableInfiniteScroll: true,
      padEnds: true,
      enlargeCenterPage: false,
      viewportFraction: isMobile ? 0.75 : 0.3,
      clipBehavior: Clip.none,
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
        return Container(
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(width: 2, color: OnlineTheme.current.border),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(width: 2, color: OnlineTheme.current.border)),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      imageSource,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(name, style: OnlineTheme.subHeader()),
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
