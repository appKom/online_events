import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/components/skeleton_loader.dart';
import 'package:online/pages/event/cards/event_card.dart';
import 'package:online/theme/themed_icon.dart';

import '/components/online_scaffold.dart';
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

    final year = date.year;
    final yearString = year.toString();

    return '$dayString. $monthString, $yearString';
  }

  Widget coverImage() {
    // No cover image
    if (article.image?.original == null) {
      return SvgPicture.asset(
        'assets/svg/online_hvit_o.svg',
        fit: BoxFit.cover,
        height: 240,
      );
    }

    // Load cover image
    return Image.network(
      article.image!.original,
      fit: BoxFit.cover,
      height: 240,
      loadingBuilder: (context, child, evt) {
        if (evt == null) return child;

        return const SkeletonLoader(height: 240);
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return SvgPicture.asset(
          'assets/svg/online_hvit_o.svg',
          fit: BoxFit.cover,
          height: 240,
        );
      },
    );
  }

  Widget authorsAndDateCard() {
    return OnlineCard(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ThemedIcon(icon: IconType.script, size: 18),
              const SizedBox(width: 8),
              Text(
                article.authors.replaceAll(', ', ',\n'),
                style: OnlineTheme.textStyle(),
                overflow: TextOverflow.visible,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ThemedIcon(icon: IconType.dateTime, size: 20),
              const SizedBox(width: 8),
              Text(
                dateToString(),
                style: OnlineTheme.textStyle(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Card header
  Widget cardHeader(String text) {
    return SizedBox(
      height: 32,
      child: Text(
        text,
        style: OnlineTheme.header(),
      ),
    );
  }

  Widget ingressCard() {
    return OnlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          cardHeader('Intro'),
          Text(
            article.ingress,
            style: OnlineTheme.textStyle(),
          ),
        ],
      ),
    );
  }

  Widget bodyCard() {
    List<dynamic> contentSegments = extractAndSplitContent(article.content);

    return OnlineCard(
      child: Column(
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
                return const SkeletonLoader(height: 200);
              },
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return SvgPicture.asset(
                  'assets/svg/online_hvit_o.svg',
                  fit: BoxFit.cover,
                );
              },
            );
          }

          return Text(segment, style: OnlineTheme.textStyle());
        }).toList(),
      ),
    );
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          coverImage(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(article.heading, style: OnlineTheme.header()),
                const SizedBox(height: 14),
                authorsAndDateCard(),
                const SizedBox(height: 24),
                ingressCard(),
                const SizedBox(height: 24),
                bodyCard(),
                const SizedBox(height: 24),
                ViewMoreArticles(scrollController: scrollController),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
