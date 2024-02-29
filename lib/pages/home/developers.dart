import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:online/components/skeleton_loader.dart';

import '/theme/theme.dart';

class DeveloperCarousel extends StatelessWidget {
  const DeveloperCarousel({
    super.key,
  });

  static Widget skeleton() {
    return Transform.scale(
      scale: 0.5,
      child: CarouselSlider(
        items: List.generate(2, (i) {
          return const SkeletonLoader(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          );
        }),
        options: _carouselOptions,
      ),
    );
  }

  Widget developerCard(DeveloperModel developer) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            border: Border.fromBorderSide(
              BorderSide(width: 2, color: OnlineTheme.grayBorder),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              developer.image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              roleBadge(developer.name),
            ],
          ),
        ),
      ],
    );
  }

  static final _carouselOptions = CarouselOptions(
    height: 200 + 15,
    enableInfiniteScroll: true,
    padEnds: true,
    enlargeCenterPage: true,
    viewportFraction: 0.65,
    enlargeFactor: 0.2,
  );

  Widget roleBadge(String role) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: OnlineTheme.yellow.darken(40),
        borderRadius: OnlineTheme.buttonRadius,
        border: const Border.fromBorderSide(
          BorderSide(color: OnlineTheme.yellow, width: 2),
        ),
      ),
      child: Center(
        child: Text(
          role,
          style: OnlineTheme.textStyle(weight: 5, size: 14, color: OnlineTheme.yellow),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<DeveloperModel> developers = [
      const DeveloperModel(
        name: 'Erlend Strøm',
        year: 2,
        image: 'assets/images/profile_picture.png',
        biography: 'Appkom-Nestleder',
      ),
      const DeveloperModel(
        name: 'Fredrik Hansteen',
        year: 2,
        image: 'assets/images/better_profile_picture.jpg',
        biography: 'Appkom-Leder',
      ),
    ];

    List<Widget> developerWidgets = developers.map((developer) => developerCard(developer)).toList();

    return CarouselSlider(
      items: developerWidgets,
      options: _carouselOptions,
    );
  }
}

class DeveloperModel {
  final String name;
  final int year;
  final String image;
  final String biography;
  final String? role;

  const DeveloperModel({
    required this.name,
    required this.year,
    required this.image,
    required this.biography,
    this.role,
  });
}
