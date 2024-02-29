import 'package:flutter/material.dart';

import '../events/events_page.dart';
import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/components/skeleton_loader.dart';
import '/core/client/client.dart';
import '/pages/home/event_card.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'article_carousel.dart';
import 'bedpres.dart';

class HomePage extends ScrollablePage {
  const HomePage({super.key});

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kommende Arrangementer',
                style: OnlineTheme.header(),
              ),
              // AnimatedButton(
              //   onTap: () {
              //     AppNavigator.navigateToPage(const InfoPage());
              //   },
              //   childBuilder: (context, hover, pointerDown) {
              //     return const Icon(
              //       Icons.info_outline,
              //       color: OnlineTheme.white,
              //       size: 25,
              //     );
              //   },
              // ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 111 * 3,
            child: ValueListenableBuilder(
              valueListenable: Client.eventsCache,
              builder: (context, events, child) {
                if (events.isEmpty) {
                  return Column(
                    children: [
                      EventCard.skeleton(),
                      EventCard.skeleton(),
                      EventCard.skeleton(),
                    ],
                  );
                }

                return ListView.builder(
                  itemCount: 3,
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
                onTap: () => AppNavigator.navigateToPage(const EventsPageDisplay()),
                behavior: HitTestBehavior.opaque,
                childBuilder: (context, hover, pointerDown) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'MER',
                        style: OnlineTheme.textStyle(weight: 5),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.navigate_next,
                          color: OnlineTheme.white,
                          size: 20,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder(
            valueListenable: Client.eventsCache,
            builder: (context, events, child) {
              if (events.isEmpty) return Bedpres.skeleton(context);
              return Bedpres(models: events);
            },
          ),
          const SizedBox(height: 24 + 24),
          Text('Artikler', style: OnlineTheme.header()),
          const SizedBox(height: 24),
          ValueListenableBuilder(
            valueListenable: Client.articlesCache,
            builder: (context, articles, child) {
              if (articles.isEmpty) return Center(child: ArticleCarousel.skeleton(context));

              return Center(child: ArticleCarousel(articles: articles.take(3).toList()));
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
