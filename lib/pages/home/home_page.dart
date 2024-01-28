import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/skeleton_loader.dart';
import 'package:online_events/core/client/client.dart';
import 'package:online_events/pages/home/event_card.dart';

import '../../components/online_scaffold.dart';
import '../../services/page_navigator.dart';
import '../../theme/theme.dart';
import '../events/events_page.dart';
import '/pages/home/promoted_article.dart';
import 'profile_button.dart';

class HomePage extends ScrollablePage {
  const HomePage({super.key});

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
    // final style = OnlineTheme.textStyle(weight: 5);
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: OnlineHeader.height(context)),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 222,
            child: FutureBuilder(
              future: Client.fetchArticles(),
              builder: (context, snapshot) {
                // Waiting for response
                if (!snapshot.hasData) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: SkeletonLoader(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }

                // No articles returned
                if (snapshot.data == null) throw Exception('TODO');

                // Articles were returned

                // TODO: Second parameter is fishy
                return PromotedArticle(article: snapshot.data!.first, articleModels: snapshot.data!);
              },
              // itemBuilder: (c, i) => PromotedArticle(
              //   article: articleModels[i],
              //   articleModels: articleModels,
              // ),
            ),
          ),
          Text(
            'Kommende Arrangementer',
            style: OnlineTheme.textStyle(weight: 7),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 111 * 2,
            child: FutureBuilder(
              future: Client.getEvents(pages: [1]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Column(
                    children: [
                      EventCard.skeleton(),
                      EventCard.skeleton(),
                    ],
                  );
                }

                if (snapshot.data == null) throw Exception('TODO');

                return ListView.builder(
                  itemCount: 2,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) => EventCard(
                    model: snapshot.data![i],
                  ),
                );
              },
            ),
          ),
          AnimatedButton(
            onTap: () => PageNavigator.navigateTo(const EventsPageDisplay()),
            behavior: HitTestBehavior.opaque,
            childBuilder: (context, hover, pointerDown) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'MER',
                    style: OnlineTheme.textStyle(weight: 4),
                  ),
                  const SizedBox(width: 2),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.navigate_next,
                      color: OnlineTheme.gray9,
                      size: 15,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          // Bedpress(models: eventModels), TODO: Re-add this somehow..
          SizedBox(height: Navbar.height(context) + 24),
        ],
      ),
    );
  }
}
