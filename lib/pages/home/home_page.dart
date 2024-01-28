import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/skeleton_loader.dart';
import 'package:online_events/core/client/client.dart';
import 'package:online_events/pages/home/bedpress.dart';
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
          SizedBox(height: OnlineHeader.height(context) + 24),
          Text(
            'Kommende Arrangementer',
            style: OnlineTheme.textStyle(size: 20, weight: 7),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 111 * 2,
            child: ValueListenableBuilder(
              valueListenable: Client.eventsCache,
              builder: (context, events, child) {
                if (events.isEmpty) {
                  return Column(
                    children: [
                      EventCard.skeleton(),
                      EventCard.skeleton(),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: 2,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) => EventCard(
                    model: events.elementAt(i),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder(
              valueListenable: Client.eventsCache,
              builder: (context, events, child) {
                if (events.isEmpty) {
                  return Center(
                    child: SkeletonLoader(
                      borderRadius: BorderRadius.circular(5),
                      width: 50,
                      height: 25,
                    ),
                  );
                }

                return AnimatedButton(
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
                );
              }),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: Client.eventsCache,
            builder: (context, events, child) {
              if (events.isEmpty) return Bedpress.skeleton();
              return Bedpress(models: events);
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12),
            child: Text(
              'Noe å lese på?',
              style: OnlineTheme.textStyle(size: 20, weight: 7),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 222,
            child: ValueListenableBuilder(
              valueListenable: Client.articlesCache,
              builder: (context, articles, child) {
                if (articles.isEmpty) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: SkeletonLoader(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }

                return PromotedArticle(article: articles.first);
              },
            ),
          ),
          SizedBox(height: Navbar.height(context) + 24),
        ],
      ),
    );
  }
}
