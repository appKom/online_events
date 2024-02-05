import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/core/models/article_model.dart';
import '/pages/article/view_more_articles.dart';
import '/theme/theme.dart';

class ArticlePage extends ScrollablePage {
  final ArticleModel article;
  final ScrollController scrollController = ScrollController();
  ArticlePage({super.key, required this.article});

  List<dynamic> extractAndSplitContent(String content) {
    RegExp exp = RegExp(r'(https?://\S+\.(jpg|jpeg|png|gif))');
    Iterable<RegExpMatch> matches = exp.allMatches(content);

    List<dynamic> segments = [];
    int lastEnd = 0;

    for (var match in matches) {
      String imgUrl = match.group(0)!;
      int startIndex = match.start;

      if (startIndex > lastEnd) {
        segments.add(content.substring(lastEnd, startIndex));
      }

      segments.add(Uri.parse(imgUrl));
      lastEnd = match.end;
    }

    // Add any remaining text
    if (lastEnd < content.length) {
      segments.add(content.substring(lastEnd));
    }

    return segments;
  }

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

  String dateToString() {
    final date = DateTime.parse(article.createdDate);

    final day = date.day;
    final dayString = day.toString().padLeft(2, '0');

    final month = date.month - 1;
    final monthString = months[month];

    return '$dayString. $monthString';
  }

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
        // buttons: const [
        //   ProfileButton(),
        // ],
        );
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);
    final topPadding = MediaQuery.of(context).padding;
    List<dynamic> contentSegments = extractAndSplitContent(article.content);
    return Padding(padding: topPadding, child:  
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        article.image?.original != null
            ? Image.network(
                article.image!.original,
                fit: BoxFit.cover,
                height: 240,
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
                    height: 240,
                  );
                },
              )
            : SvgPicture.asset(
                'assets/svg/online_hvit_o.svg',
                fit: BoxFit.cover,
                height: 240,
              ),
        Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Text(
                article.heading,
                style: OnlineTheme.textStyle(size: 20, weight: 7),
              ),
              const SizedBox(height: 14),
              Text(
                'Skrevet av: ${article.authors},   ${dateToString()}',
                style: OnlineTheme.textStyle(),
              ),
              const Separator(margin: 20),
              Text(
                article.ingress,
                style: OnlineTheme.textStyle(weight: 6),
              ),
              const Separator(
                margin: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: contentSegments.map((segment) {
                  if (segment is Uri) {
                    return Image.network(
                      segment.toString(),
                      fit: BoxFit.cover,
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
                  } else {
                    return Text(
                      segment,
                      style: OnlineTheme.textStyle(),
                    );
                  }
                }).toList(),
              ),

              const SizedBox(
                height: 20,
              ),
              ViewMoreArticles(
                scrollController: scrollController,
              ),
              // ... other content based on the article data ...
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    ),
    );
  }
}
