import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:online/components/image_default.dart';

import '/components/animated_button.dart';
import '/components/icon_label.dart';
import '/components/skeleton_loader.dart';
import '/core/models/article_model.dart';
import '/pages/article/article_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';

class ArticleCarousel extends StatelessWidget {
  final List<ArticleModel> articles;
  const ArticleCarousel({super.key, required this.articles});

  static const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mai',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  int calculateReadingTime(String heading, String ingress) {
    int wordCount = countWords(heading) + countWords(ingress);
    return ((wordCount / 238) + 1).ceil(); // Dividing by 238 and rounding up
  }

  int countWords(String text) {
    // Counts the number of words in a given string
    return text.split(' ').where((word) => word.isNotEmpty).length;
  }

  String dateToString(ArticleModel article) {
    final date = DateTime.parse(article.createdDate);

    final day = date.day;
    final dayString = day.toString().padLeft(2, '0');

    final month = date.month - 1; // Months go from 1-12 but we need an index of 0-11
    final monthString = months[month];

    return '$dayString. $monthString';
  }

  static Widget skeleton(BuildContext context) {
    return CarouselSlider(
      items: List.generate(3, (i) {
        return const SkeletonLoader(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        );
      }),
      options: getCarouselOptions(context),
    );
  }

  Widget coverImage(ArticleModel article) {
    if (article.image?.original == null) {
      return const ImageDefault();
    }

    return Image.network(
      article.image!.original,
      loadingBuilder: (context, child, evt) {
        if (evt == null) return child;

        return const SkeletonLoader();
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const ImageDefault();
      },
    );
  }

  Widget articleCard(ArticleModel article) {
    final timeToRead = calculateReadingTime(article.content, article.ingress);
    return AnimatedButton(
      onTap: () => AppNavigator.navigateToPage(ArticlePage(article: article)),
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
                    child: coverImage(article),
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
                          article.heading,
                          style: OnlineTheme.subHeader(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconLabel(
                              icon: IconType.dateTime,
                              label: dateToString(article),
                              fontSize: 15,
                            ),
                            IconLabel(
                              icon: IconType.clock,
                              label: '$timeToRead min',
                              fontSize: 15,
                            ),
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

  static getCarouselOptions(BuildContext context) {
    final isMobile = OnlineTheme.isMobile(context);

    return CarouselOptions(
      height: 300,
      enableInfiniteScroll: true,
      padEnds: true,
      enlargeCenterPage: isMobile,
      viewportFraction: isMobile ? 0.75 : 0.3,
      enlargeFactor: 0.2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: getCarouselOptions(context),
      items: List.generate(
        articles.length,
        (i) {
          return articleCard(
            articles[i],
          );
        },
      ),
    );
  }
}
