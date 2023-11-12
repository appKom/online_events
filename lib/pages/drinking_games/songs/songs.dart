import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';
import 'fader_abraham.dart';
import 'lambo.dart';
import 'nu_klinger.dart';

class DrikkeSanger extends StatelessWidget {
  const DrikkeSanger({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Sanger',
          style: OnlineTheme.eventHeader,
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SongCard(
                  name: 'Lambo',
                  imageSource: 'assets/images/lambo.jpg',
                  onTap: () => PageNavigator.navigateTo(
                    const LamboPage(),
                  ),
                ),
                SongCard(
                  name: 'Nu Klinger',
                  imageSource: 'assets/images/nu_klinger.jpg',
                  onTap: () => PageNavigator.navigateTo(
                    const NuKlingerPage(),
                  ),
                ),
                SongCard(
                  name: 'Fader Abraham',
                  imageSource: 'assets/images/faderabraham.png',
                  onTap: () => PageNavigator.navigateTo(
                    const FaderAbrahamPage(),
                  ),
                ),
              ],
            ),
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
    return Container(
      width: 222,
      margin: const EdgeInsets.only(right: 24),
      child: AnimatedButton(
        onPressed: onTap,
        scale: 0.9,
        child: ClipRRect(
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
        ),
      ),
    );
  }
}
