import 'package:flutter/cupertino.dart';
import 'package:online_events/core/models/article_model.dart';
import '/components/animated_button.dart';
import '/pages/article/article_page.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';

class PromotedArticle extends StatelessWidget {
  final ArticleModel article;
  const PromotedArticle({super.key, required this.article});

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
    return (wordCount / 238).ceil(); // Dividing by 238 and rounding up
  }

  int countWords(String text) {
    // Counts the number of words in a given string
    return text.split(' ').where((word) => word.isNotEmpty).length;
  }


  String dateToString() {
    final date = DateTime.parse(article.createdDate);

    final day = date.day;
    final dayString = day.toString().padLeft(2, '0');

    final month = date.month - 1; // Months go from 1-12 but we need an index of 0-11
    final monthString = months[month];

    // TODO: If an event spans multiple days, show 01.-05. January
    // TODO: If start and end month is different, shorten to 28. Jan - 03. Feb

    return '$dayString. $monthString';
  }

  

  @override
  Widget build(BuildContext context) {
    final timeToRead = calculateReadingTime(article.content, article.ingress);
    final readingTimeText = "$timeToRead min å lese";
    return AnimatedButton(
      onTap: () => PageNavigator.navigateTo(ArticlePage(article: article)),
      scale: 0.95,
      childBuilder: (context, hover, pointerDown) {
        return SizedBox(
          height: 222,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: Image.network(
                    article.image?.original ?? 'assets/svg/online_hvit_o.svg', // Modify this line
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Positioned.fill(child: Container(color: OnlineTheme.gray13)),
                      Positioned(
                        left: 20,
                        bottom: 60,
                        child: Text(
                          article.heading, // Modify this line
                          style: OnlineTheme.textStyle(weight: 5),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 42,
                        child: Text(
                          article.authors, // Modify this line
                          style: OnlineTheme.textStyle(weight: 4, size: 12),
                        ),
                      ),
                      // ... (other Positioned widgets)
                      Positioned(
                        bottom: 12,
                        left: 20,
                        child: Text(
                          '${dateToString()} • $readingTimeText',
                          style: OnlineTheme.textStyle(
                            size: 14,
                            weight: 5,
                            color: OnlineTheme.gray9,
                          ),
                        ),
                      ),
                    ],
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
