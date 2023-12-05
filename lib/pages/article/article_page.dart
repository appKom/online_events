import 'package:flutter/material.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/separator.dart';
import 'package:online_events/core/models/article_model.dart';
import 'package:online_events/pages/article/view_more_articles.dart';
import 'package:online_events/pages/home/profile_button.dart';

import 'package:online_events/theme/theme.dart';
import '../../components/online_scaffold.dart';

class ArticlePage extends ScrollablePage {
  final ArticleModel article; // Add this line
  final List<ArticleModel> articleModels;
  final ScrollController scrollController = ScrollController();
  ArticlePage(
      {super.key,
      required this.article,
      required this.articleModels}); // Modify this line

  List<dynamic> extractAndSplitContent(String content) {
    RegExp exp = RegExp(r'(https?://\S+\.(jpg|jpeg|png|gif))');
    Iterable<RegExpMatch> matches = exp.allMatches(content);

    List<dynamic> segments = [];
    int lastEnd = 0;

    for (var match in matches) {
      String imgUrl = match.group(0)!;
      int startIndex = match.start;

      // Add text segment
      if (startIndex > lastEnd) {
        segments.add(content.substring(lastEnd, startIndex));
      }

      // Add image URL
      segments.add(Uri.parse(imgUrl));
      lastEnd = match.end;
    }

    // Add any remaining text
    if (lastEnd < content.length) {
      segments.add(content.substring(lastEnd));
    }

    return segments;
  }

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
      buttons: const [
        ProfileButton(),
      ],
    );
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);
    List<dynamic> contentSegments = extractAndSplitContent(article.content);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: OnlineHeader.height(context)),
        Image.network(
          article.image?.original ??
              'assets/images/fadderuka.png', // Use the article image
          fit: BoxFit.cover,
          height: 267,
        ),
        Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Text(
                article.heading, // Use the article heading
                style: OnlineTheme.textStyle(size: 20, weight: 7),
              ),
              const SizedBox(height: 14),
              Text(
                'Skrevet av: ${article.authors}', // Use the article authors
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
                    // If segment is an image URL
                    return Image.network(segment.toString());
                  } else {
                    // If segment is a text
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
              ViewMoreArticles(articleModels: articleModels, scrollController: scrollController, ),
              // ... other content based on the article data ...
              SizedBox(height: Navbar.height(context) + 40),
            ],
          ),
        ),
      ],
    );
  }
}
