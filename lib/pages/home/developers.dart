import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:online/components/skeleton_loader.dart';

import '/theme/theme.dart';

class DeveloperCarousel extends StatelessWidget {
  const DeveloperCarousel({
    super.key,
  });

  static Widget skeleton() {
    return CarouselSlider(
      items: List.generate(2, (i) {
        return const SkeletonLoader(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        );
      }),
      options: _carouselOptions,
    );
  }

  Widget developerCard(DeveloperModel developer) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 250,
          height: 350,
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
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: [
            //     // Container(
            //     //   decoration: const BoxDecoration(
            //     //     border: Border(
            //     //       bottom: BorderSide(width: 2, color: OnlineTheme.grayBorder),
            //     //     ),
            //     //   ),
            //     //   child: AspectRatio(
            //     //     aspectRatio: 8 / 5,
            //     //     child: Image.asset(
            //     //       developer.image,
            //     //       fit: BoxFit.cover,
            //     //       alignment: Alignment.center,
            //     //     ),
            //     //   ),
            //     // ),
            //     // Expanded(
            //     //   child: Padding(
            //     //     padding: const EdgeInsets.all(20),
            //     //     child: Column(
            //     //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //     //       children: [
            //     //         Text(
            //     //           developer.name,
            //     //           style: OnlineTheme.subHeader(),
            //     //         ),
            //     //         // Text(developer.biography, style: OnlineTheme.textStyle()),
            //     //         Row(
            //     //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     //           children: [
            //     //             IconLabel(
            //     //               icon: IconType.education,
            //     //               iconSize: 18,
            //     //               label: '${developer.year.toString()}. klasse',
            //     //             ),
            //     //             // IconLabel(icon: IconType.userFilled, label: '')
            //     //           ],
            //     //         ),
            //     //         const SizedBox(height: 10),
            //     //       ],
            //     //     ),
            //     //   ),
            //     // ),
            //   ],
            // ),
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
    height: 350 + 15,
    enableInfiniteScroll: true,
    padEnds: true,
    enlargeCenterPage: true,
    viewportFraction: 0.75,
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
        name: 'Fredrik Hansteen',
        year: 2,
        image: 'assets/images/better_profile_picture.jpg',
        biography: 'Appkom-Leder',
      ),
      const DeveloperModel(
        name: 'Erlend Strøm',
        year: 2,
        image: 'assets/images/profile_picture.png',
        biography: 'Appkom-Nestleder',
      ),
    ];

    List<Widget> developerWidgets = developers.map((developer) => developerCard(developer)).toList();

    // return Column(
    //   children: [
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //       children: [
    //         developerCard(developers[0]),
    //         developerCard(developers[1]),
    //       ],
    //     ),
    //   ],
    // );

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
