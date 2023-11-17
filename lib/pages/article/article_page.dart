import 'package:flutter/material.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/separator.dart';
import 'package:online_events/core/models/article_model.dart';
import 'package:online_events/pages/home/profile_button.dart';

import 'package:online_events/theme/theme.dart';
import '../../components/online_scaffold.dart';

class ArticlePage extends ScrollablePage {
  final ArticleModel article; // Add this line

  const ArticlePage({super.key, required this.article}); // Modify this line

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
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: OnlineHeader.height(context)),
        Image.network(
          article.image?.original ?? 'assets/images/fadderuka.png', // Use the article image
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
              const SizedBox(height:14),
              Text(
                'Skrevet av: ${article.authors}', // Use the article authors
                style: OnlineTheme.textStyle(),
              ),
              const Separator(margin: 20),
              Text(
                article.ingress,
                style: OnlineTheme.textStyle(weight: 6),
              ),
              const Separator(margin: 15,),
              Text(
                article.content, // Use the article content
                style: OnlineTheme.textStyle(),
              ),
              // ... other content based on the article data ...
              SizedBox(height: Navbar.height(context) + 40),
            ],
          ),
        ),
      ],
    );
  }
}