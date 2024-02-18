import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:online/services/app_navigator.dart';

import '/components/animated_button.dart';
import '/theme/theme.dart';
import 'fader_abraham.dart';
import 'lambo.dart';
import 'nu_klinger.dart';

class DrikkeSanger extends StatelessWidget {
  const DrikkeSanger({super.key});

  @override
  Widget build(BuildContext context) {
    final options = CarouselOptions(
      height: 200,
      enableInfiniteScroll: true,
      enlargeCenterPage: true,
      padEnds: true,
      viewportFraction: 0.7,
      enlargeFactor: 0.2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sanger',
          style: OnlineTheme.header(),
        ),
        const SizedBox(height: 24),
        CarouselSlider(
          options: options,
          items: [
            SongCard(
              name: 'Lambo',
              imageSource: 'assets/images/lambo.jpg',
              onTap: () => AppNavigator.navigateToPage(
                const LamboPage(),
              ),
            ),
            SongCard(
              name: 'Nu Klinger',
              imageSource: 'assets/images/nu_klinger.jpg',
              onTap: () => AppNavigator.navigateToPage(
                const NuKlingerPage(),
              ),
            ),
            SongCard(
              name: 'Fader Abraham',
              imageSource: 'assets/images/faderabraham.png',
              onTap: () => AppNavigator.navigateToPage(
                const FaderAbrahamPage(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SongCard extends StatelessWidget {
  final String name;
  final String imageSource;
  final void Function() onTap;

  const SongCard({
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
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(width: 2, color: OnlineTheme.grayBorder),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2, color: OnlineTheme.grayBorder),
                    ),
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
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   right: 0,
                //   child: Container(
                //     padding: const EdgeInsets.all(12), // Add some padding around the text
                //     color: Colors.black.withOpacity(0.5), // Semi-transparent background for the text
                //     child: Text(
                //       name,
                //       style: OnlineTheme.textStyle(weight: 7, size: 20),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
