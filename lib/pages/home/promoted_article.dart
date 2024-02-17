import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';

import '../../theme/themed_icon.dart';
import '/components/animated_button.dart';
import '/core/models/article_model.dart';
import '/pages/article/article_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

class PromotedArticles extends StatelessWidget {
  final List<ArticleModel> articles;
  const PromotedArticles({super.key, required this.articles});

  static const months = [
    'Januar',
    'Februar',
    'Mars',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Desember',
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

  Widget articleCard(ArticleModel article) {
    final timeToRead = calculateReadingTime(article.content, article.ingress);
    // final readingTimeText = "$timeToRead min å lese";
    return AnimatedButton(
      onTap: () => AppNavigator.navigateToPage(ArticlePage(article: article)),
      childBuilder: (context, hover, pointerDown) {
        return Container(
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
                    child: Image.network(
                      article.image?.original ?? 'assets/svg/online_hvit_o.svg', // Modify this line
                      fit: BoxFit.cover,
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
                          article.heading, // Modify this line
                          style: OnlineTheme.textStyle(weight: 5, color: OnlineTheme.gray9),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const ThemedIcon(icon: IconType.script, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              article.authors.replaceAll(', ', ',\n'),
                              style: OnlineTheme.textStyle(size: 15),
                              overflow: TextOverflow.visible,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const ThemedIcon(icon: IconType.dateTime, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  dateToString(article),
                                  style: OnlineTheme.textStyle(size: 15),
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const ThemedIcon(icon: IconType.clock, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  '$timeToRead min',
                                  style: OnlineTheme.textStyle(size: 15),
                                  overflow: TextOverflow.visible,
                                ),
                              ],
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

  @override
  Widget build(BuildContext context) {
    final options = CarouselOptions(
      height: 350,
      enableInfiniteScroll: true,
      padEnds: true,
      enlargeCenterPage: true,
      viewportFraction: 0.8,
      enlargeFactor: 0.2,
    );

    return CarouselSlider(
      options: options,
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
