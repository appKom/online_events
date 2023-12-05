import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/core/models/article_model.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/pages/article/second_article_page.dart';
import 'package:online_events/pages/event/event_page.dart';

import '/services/page_navigator.dart';
import '/pages/home/event_card.dart';
import '/theme/themed_icon.dart';

import '../../theme/theme.dart';

class ViewMoreArticles extends StatelessWidget {
  final List<ArticleModel> articleModels; // Change to use EventModel
  const ViewMoreArticles({super.key, required this.articleModels});

  @override
  Widget build(BuildContext context) {
    // Filter models where eventType is 2 and 3
    final modelsToShow = articleModels.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Les mer',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 266,
          child: ListView.builder(
            itemCount: 5, // Use count of filtered models
            itemBuilder: (context, index) => buildItem(context, index, modelsToShow),
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }

  Widget? buildItem(BuildContext context, int index, List<ArticleModel> modelsToShow) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      child: MoreArticleCard(
        articleModel: modelsToShow[index], // Use the model from the filtered list
      ),
    );
  }
}

class MoreArticleCard extends StatelessWidget {
  final ArticleModel articleModel;

  const MoreArticleCard({super.key, required this.articleModel});

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
    return ((wordCount / 238)+1).ceil(); // Dividing by 238 and rounding up
  }

  int countWords(String text) {
    // Counts the number of words in a given string
    return text.split(' ').where((word) => word.isNotEmpty).length;
  }


  String dateToString() {
    final date = DateTime.parse(articleModel.createdDate);

    final day = date.day;
    final dayString = day.toString().padLeft(2, '0');

    final month = date.month - 1; // Months go from 1-12 but we need an index of 0-11
    final monthString = months[month];

    // TODO: If an event spans multiple days, show 01.-05. January
    // TODO: If start and end month is different, shorten to 28. Jan - 03. Feb

    return '$dayString. $monthString';
  }

  void showInfo() {
    PageNavigator.navigateTo(SecondArticlePage(article: articleModel));
  }
  @override
  Widget build(BuildContext context) {
    final timeToRead = calculateReadingTime(articleModel.content, articleModel.ingress);
    final readingTimeText = "$timeToRead min å lese";
    return AnimatedButton(
      onTap: showInfo,
      childBuilder: (context, hover, pointerDown) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 266,
            color: OnlineTheme.gray13,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 2,
                  child: Image.network(
                    articleModel.image?.original ?? 'assets/svg/online_hvit_o.svg', // Modify this line
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
                          articleModel.heading, // This line will now wrap text
                          style: OnlineTheme.textStyle(weight: 5),
                          overflow: TextOverflow.visible, // Ensures text wraps instead of being truncated
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 40,
                        child: Text(
                          articleModel.authors, // Modify this line
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
