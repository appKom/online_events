import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:online/pages/games/hundred_questions/hundred_questions_page.dart';
import 'package:online/pages/games/roulette_page.dart';

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
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          DrikkeSanger(carouselOptions: getCarouselOptions(context)),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          Text('Spill', style: OnlineTheme.header()),
          const SizedBox(height: 24),
          CarouselSlider(
            items: [
              GameCard(
                name: 'Terning',
                imageSource: 'assets/images/diceHeader.jpg',
                onTap: () {
                  AppNavigator.globalNavigateTo(const DicePage());
                },
              ),
              GameCard(
                name: 'Hundre spørsmål',
                imageSource: 'assets/images/hundred-questions.png',
                onTap: () {
                  AppNavigator.globalNavigateTo(HundredQuestionsInfo());
                },
              ),
              GameCard(
                name: 'SpinLine',
                imageSource: 'assets/images/SpinLine.png',
                onTap: () {
                  AppNavigator.globalNavigateTo(const SpinLinePage());
                },
              ),
              GameCard(
                name: 'Roulette',
                imageSource: 'assets/images/roulette.png',
                onTap: () {
                  AppNavigator.globalNavigateTo(const RoulettePage());
                },
              ),
              GameCard(
                name: 'Bits',
                imageSource: 'assets/images/bits.png',
                onTap: () {
                  AppNavigator.globalNavigateTo(const BitsHomePage());
                },
              ),
            ],
            options: getCarouselOptions(context),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  static getCarouselOptions(BuildContext context) {
    final isMobile = OnlineTheme.isMobile(context);

    return CarouselOptions(
      height: 200,
      enableInfiniteScroll: true,
      padEnds: true,
      enlargeCenterPage: isMobile,
      viewportFraction: isMobile ? 0.75 : 0.3,
      enlargeFactor: 0.2,
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
