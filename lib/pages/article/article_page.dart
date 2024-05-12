import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';

import '../home/article_carousel.dart';
import '/components/icon_label.dart';
import '/components/online_scaffold.dart';
import '/components/skeleton_loader.dart';
import '/core/client/client.dart';
import '/core/models/article_model.dart';
import '/pages/event/cards/event_card.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';

class ArticlePage extends ScrollablePage {
  final ArticleModel article;
  final ScrollController scrollController = ScrollController();
  ArticlePage({super.key, required this.article});

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
    return CachedNetworkImage(
      imageUrl: article.image!.original,
      fit: BoxFit.cover,
      height: 240,
      placeholder: (context, url) => const SkeletonLoader(height: 240),
      errorWidget: (context, url, error) => SvgPicture.asset(
        'assets/svg/online_hvit_o.svg',
        fit: BoxFit.cover,
        height: 240,
      ),
    );
  }

  Widget authorsAndDateCard() {
    return OnlineCard(
      child: Column(
        children: [
          IconLabel(icon: IconType.script, iconSize: 18, label: article.authors.replaceAll(', ', ',\n')),
          const SizedBox(height: 16),
          IconLabel(icon: IconType.dateTime, label: dateToString()),
        ],
      ),
    );
  }

  static MarkdownStyleSheet markdownTheme() {
    final theme = OnlineTheme.current;

    return MarkdownStyleSheet(
      p: OnlineTheme.textStyle(color: theme.fg),
      h1: TextStyle(color: theme.fg),
      h2: TextStyle(color: theme.fg),
      h3: TextStyle(color: theme.fg),
      h4: TextStyle(color: theme.fg),
      h5: TextStyle(color: theme.fg),
      h6: TextStyle(color: theme.fg),
    );
  }

  Widget articleCard(BuildContext context) {
    final mdTheme = markdownTheme();

    return OnlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MarkdownBody(
            data: '${article.ingress}\n',
            styleSheet: mdTheme,
            onTapLink: (text, href, title) {
              if (href == null) return;
              Client.launchInBrowser(href);
            },
          ),
          MarkdownBody(
            data: article.content,
            styleSheet: mdTheme,
            onTapLink: (text, href, title) {
              if (href == null) return;
              Client.launchInBrowser(href);
            },
          ),
        ],
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
            padding: OnlineTheme.horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(article.heading, style: OnlineTheme.header()),
                const SizedBox(height: 24),
                authorsAndDateCard(),
                const SizedBox(height: 24),
                articleCard(context),
                const SizedBox(height: 24),
                Text('Les Mer', style: OnlineTheme.header()),
                const SizedBox(height: 24),
                ArticleCarousel(
                  articles: Client.articlesCache.value.toList()..removeWhere((a) => a.heading == article.heading),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
