import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/services/app_navigator.dart';

import '../../core/client/client.dart';
import '/components/animated_button.dart';
import '/core/models/article_model.dart';
import '/pages/article/article_page.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';

class ViewMoreArticles extends StatelessWidget {
  final ScrollController scrollController;
  const ViewMoreArticles({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final modelsToShow = Client.articlesCache.value.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Les mer',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          child: SizedBox(
            height: 266,
            child: ListView.builder(
              itemCount: 5, // Use count of filtered models
              itemBuilder: (context, index) => buildItem(context, index, modelsToShow),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    );
  }

  Widget? buildItem(BuildContext context, int index, List<ArticleModel> modelsToShow) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      child: MoreArticleCard(
        articleModel: modelsToShow[index],
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
    return ((wordCount / 238) + 1).ceil(); // Dividing by 238 and rounding up
  }

  int countWords(String text) {
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
    AppNavigator.navigateToPage(ArticlePage(
      article: articleModel,
    ));
  }

  List<String> splitHeading(String heading) {
    if (heading.length <= 30) {
      return [heading, ''];
    } else {
      int splitIndex = heading.lastIndexOf(' ', 30);
      if (splitIndex == -1) {
        splitIndex = 30;
      }
      final part1 = heading.substring(0, splitIndex);
      final part2 = heading.substring(splitIndex + 1);
      return [part1, part2];
    }
  }

  Widget imageOrDefault(String? source) {
    if (source == null) return SvgPicture.asset('assets/svg/online_hvit_o.svg', fit: BoxFit.cover);

    return Image.network(
      source,
      fit: BoxFit.cover,
      alignment: Alignment.bottomCenter,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return SvgPicture.asset(
          'assets/svg/online_hvit_o.svg',
          fit: BoxFit.cover,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeToRead = calculateReadingTime(articleModel.content, articleModel.ingress);
    final readingTimeText = "$timeToRead min å lese";
    final List<String> headingParts = splitHeading(articleModel.heading);
    final String part1 = headingParts[0];
    final String part2 = headingParts[1];

    String formatAuthors(String authors) {
      final authorNames = authors.split(',').map((author) {
        final names = author.trim().split(' ');
        return names.isNotEmpty ? names[0] : '';
      }).toList();

      return authorNames.join(' og ');
    }

    final formattedAuthors =
        articleModel.authors.length > 28 ? formatAuthors(articleModel.authors) : articleModel.authors;

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
                imageOrDefault(articleModel.image?.original),
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Positioned.fill(child: Container(color: OnlineTheme.gray13)),
                      Positioned(
                        left: 20,
                        bottom: 80,
                        child: Text(
                          part1, // This line will now wrap text
                          style: OnlineTheme.textStyle(weight: 5),
                          overflow: TextOverflow.ellipsis, // Truncate with ellipsis if too long
                          maxLines: 2,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 62,
                        child: Text(
                          part2,
                          style: OnlineTheme.textStyle(weight: 5),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 35,
                        child: Text(
                          formattedAuthors, // Modify this line
                          style: OnlineTheme.textStyle(weight: 4, size: 14),
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
