import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/components/skeleton_loader.dart';

import '/components/animated_button.dart';
import '/components/icon_label.dart';
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

    // TODO: If an event spans multiple days, show 01.-05. January
    // TODO: If start and end month is different, shorten to 28. Jan - 03. Feb

    return '$dayString. $monthString';
  }

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

  // Widget coverImage(String? url) {
  //   if (url != null) {
  //     Container(
  //       decoration: const BoxDecoration(
  //         border: Border(
  //           bottom: BorderSide(width: 2, color: OnlineTheme.grayBorder),
  //         ),
  //       ),
  //       child: AspectRatio(
  //         aspectRatio: 16 / 9,
  //         child: Image.network(
  //           url,
  //           fit: BoxFit.cover,
  //           alignment: Alignment.bottomCenter,
  //         ),
  //       ),
  //     );
  //   }

  //   return
  // }

  Widget coverImage(ArticleModel article) {
    if (article.image?.original == null) {
      return SvgPicture.asset(
        'assets/svg/online_hvit_o.svg',
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      article.image!.original,
      loadingBuilder: (context, child, evt) {
        if (evt == null) return child;

        return const SkeletonLoader();
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return SvgPicture.asset(
          'assets/svg/online_hvit_o.svg',
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget articleCard(ArticleModel article) {
    final timeToRead = calculateReadingTime(article.content, article.ingress);
    // final readingTimeText = "$timeToRead min å lese";
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
                        // IconLabel(
                        //   icon: IconType.script,
                        //   label: article.authors.replaceAll(', ', ',\n'),
                        //   fontSize: 15,
                        //   iconSize: 18,
                        // ),
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
    return CarouselSlider(
      options: _carouselOptions,
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
