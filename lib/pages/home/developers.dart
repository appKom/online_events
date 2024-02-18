import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:online/components/skeleton_loader.dart';

import '/components/animated_button.dart';
import '/components/icon_label.dart';
import '/core/models/article_model.dart';
import '/pages/article/article_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';

class DeveloperCarousel extends StatelessWidget {
  const DeveloperCarousel({
    super.key,
  });

  static Widget skeleton() {
    return CarouselSlider(
      items: List.generate(3, (i) {
        return const SkeletonLoader(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        );
      }),
      options: _carouselOptions,
    );
  }

  Widget developerCard(DevloperModel devloper) {
    return AnimatedButton(
      // onTap: () => AppNavigator.navigateToPage(ArticlePage(article: article)),
      childBuilder: (context, hover, pointerDown) {
        return Container(
          width: 250,
          height: 300,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      devloper.image,
                      fit: BoxFit.fill,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          devloper.name,
                          style: OnlineTheme.subHeader(),
                        ),
                        // const SizedBox(height: 10),
                        Text(devloper.biography, style: OnlineTheme.textStyle(size: 16)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                            
                               '${devloper.year.toString()}. klasse',
                              style: OnlineTheme.textStyle(size: 16),
                            ),
                            // IconLabel(
                            //   icon: IconType.clock,
                            //   label: '$timeToRead min',
                            //   fontSize: 15,
                            // ),
                          ],
                        )
                      ],
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

  static final _carouselOptions = CarouselOptions(
    height: 300,
    enableInfiniteScroll: true,
    padEnds: true,
    enlargeCenterPage: true,
    viewportFraction: 0.75,
    enlargeFactor: 0.2,
  );

  @override
  Widget build(BuildContext context) {
    List<DevloperModel> developers = [
      const DevloperModel(name: 'Fredrik Hansteen', year: 2, image: 'assets/images/better_profile_picture.jpg', biography: 'Oppe og nikker?'),
      const DevloperModel(name: 'Erlend Strøm', year: 2, image: 'assets/images/profile_picture.png', biography: 'Heisann, jeg er en utvikler'),
    ];
    List<Widget> developerWidgets = developers.map((developer) => developerCard(developer)).toList();

    return CarouselSlider(
      items: developerWidgets,
      options: _carouselOptions,
    );
  }
}

class DevloperModel {
  final String name;
  final int year;
  final String image;
  final String biography;

  const DevloperModel({required this.name, required this.year, required this.image, required this.biography});
}
