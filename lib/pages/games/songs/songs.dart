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
      enableInfiniteScroll: true,
      enlargeCenterPage: true,
      padEnds: true,
      viewportFraction: 0.7,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sanger',
          style: OnlineTheme.header(),
        ),
        const SizedBox(height: 10),
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Colors.transparent, Colors.white, Colors.white, Colors.transparent],
              stops: [0.0, 0.1, 0.9, 1.0], // Adjust these stops to control the fade effect
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: CarouselSlider(
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
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: OnlineTheme.gray13,
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
                    padding: const EdgeInsets.all(12), // Add some padding around the text
                    color: Colors.black.withOpacity(0.5), // Semi-transparent background for the text
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
