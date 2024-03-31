import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/pages/home/hobbies.dart';

import '../../core/models/hobby_model.dart';
import '/components/online_scaffold.dart';
import '/components/skeleton_loader.dart';
import '/core/client/client.dart';
import '/pages/event/cards/event_card.dart';
import '/theme/theme.dart';

class HobbyPage extends ScrollablePage {
  final HobbyModel hobby;
  final ScrollController scrollController = ScrollController();
  HobbyPage({super.key, required this.hobby});

  Widget coverImage() {
    // No cover image
    if (hobby.image?.original == null) {
      return SvgPicture.asset(
        'assets/svg/online_hvit_o.svg',
        fit: BoxFit.cover,
        height: 240,
      );
    }

    // Load cover image
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: hobby.image!.original,
        fit: BoxFit.cover,
        height: 240,
        placeholder: (context, url) => const SkeletonLoader(height: 240),
        errorWidget: (context, url, error) => SvgPicture.asset(
          'assets/svg/online_hvit_o.svg',
          fit: BoxFit.cover,
          height: 240,
        ),
      ),
    );
  }

  static final markdownTheme = MarkdownStyleSheet(
    p: OnlineTheme.textStyle(color: OnlineTheme.white),
    h1: const TextStyle(color: OnlineTheme.white),
    h2: const TextStyle(color: OnlineTheme.white),
    h3: const TextStyle(color: OnlineTheme.white),
    h4: const TextStyle(color: OnlineTheme.white),
    h5: const TextStyle(color: OnlineTheme.white),
    h6: const TextStyle(color: OnlineTheme.white),
  );

  Widget articleCard(BuildContext context) {
    return OnlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MarkdownBody(
            data: '${hobby.description}\n',
            styleSheet: markdownTheme,
            onTapLink: (text, href, title) {
              if (href == null) return;
              Client.launchInBrowser(href);
            },
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            'Les mer:',
            style: OnlineTheme.textStyle(),
          ),
          const SizedBox(
            height: 12,
          ),
          MarkdownBody(
            data: hobby.readMoreLink ?? '',
            styleSheet: markdownTheme,
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
                Text(hobby.title, style: OnlineTheme.header()),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                articleCard(context),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                Hobbies(hobbies: Client.hobbiesCache.value),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
