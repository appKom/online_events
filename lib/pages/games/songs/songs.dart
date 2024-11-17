import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/components/animated_button.dart';
import '/theme/theme.dart';

class DrikkeSanger extends StatelessWidget {
  const DrikkeSanger({super.key, required this.carouselOptions});

  final CarouselOptions carouselOptions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sanger',
          style: OnlineTheme.header(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        CarouselSlider(
          options: carouselOptions,
          items: [
            SongCard(
              name: 'Lambo',
              imageSource: 'assets/images/lambo.jpg',
              onTap: () => context.go('/social/lambo'),
            ),
            SongCard(
              name: 'Nu Klinger',
              imageSource: 'assets/images/nu_klinger.jpg',
              onTap: () => context.go('/social/nu_klinger'),
            ),
            SongCard(
              name: 'Studenter Visen',
              imageSource: 'assets/images/studentervisen.png',
              onTap: () => context.go('/social/studenter_visen'),
            ),
            SongCard(
              name: 'Kamerater Hev Nu Glasset!',
              imageSource: 'assets/images/kameraterhevglasset.png',
              onTap: () => context.go('/social/kamerater_hev_glasset'),
            ),
            SongCard(
              name: 'Himmelseng',
              imageSource: 'assets/images/himmelseng.png',
              onTap: () => context.go('/social/himmelseng'),
            ),
            SongCard(
              name: 'Fader Abraham',
              imageSource: 'assets/images/faderabraham.png',
              onTap: () => context.go('/social/fader_abraham'),
            ),
            SongCard(
              name: 'We like to drink with',
              imageSource: 'assets/images/we_like_to_drink.png',
              onTap: () => context.go('/social/we_like_to_drink'),
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
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(BorderSide(width: 2, color: OnlineTheme.current.border)),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2, color: OnlineTheme.current.bg),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
