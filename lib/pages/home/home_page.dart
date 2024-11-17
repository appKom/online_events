import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online/pages/home/christmas/christmas_countdown.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart';
import '/core/models/event_model.dart';
import '/pages/home/event_card.dart';
import '/pages/home/hobbies.dart';
import '/theme/theme.dart';
import 'article_carousel.dart';
import 'bedpres.dart';

class HomePage extends ScrollablePage {
  const HomePage({super.key});
  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    final theme = OnlineTheme.current;

    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final day = DateTime.now().day;

    return Padding(
      padding: EdgeInsets.only(top: padding.top + 64, bottom: 64),
      child: Column(
        children: [
          // Show christmas countdown as long as it is 2024 and not after December 24th
          if (year == 2024 && !(month == 12 && day > 24)) ChristmasCountdown(),
          Padding(
            padding: EdgeInsets.only(left: padding.left, right: padding.right),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Kommende Arrangementer',
                  style: OnlineTheme.header(),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 24),
                  child: ValueListenableBuilder(
                    valueListenable: Client.eventsCache,
                    builder: (context, events, child) {
                      final now = DateTime.now();

                      final List<EventModel> futureEvents = [];

                      for (MapEntry<int, EventModel> entry in events.entries) {
                        final event = entry.value;
                        final eventDate = DateTime.parse(event.endDate);

                        if (eventDate.isAfter(now)) {
                          futureEvents.add(event);
                        }
                      }

                      if (futureEvents.isEmpty) {
                        return Column(
                          children: List.generate(4, (_) => EventCard.skeleton()),
                        );
                      }
                      double eventHeight = 400;

                      if (futureEvents.length < 4) {
                        eventHeight = futureEvents.length * 100;
                      }

                      return SizedBox(
                        height: eventHeight,
                        child: ListView.builder(
                          itemCount: futureEvents.length,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => EventCard(
                            model: futureEvents[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: Client.eventsCache,
                  builder: (context, events, child) {
                    return AnimatedButton(
                      onTap: () {
                        if (events.isEmpty) return;
                        // AppNavigator.navigateToPage(const EventsPage());
                        context.go('/events');
                      },
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
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.navigate_next,
                                color: OnlineTheme.current.fg,
                                size: 20,
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24 + 24),
                ValueListenableBuilder(
                  valueListenable: Client.eventsCache,
                  builder: (context, events, child) {
                    if (events.isEmpty) return Bedpres.skeleton(context);
                    return Bedpres(models: events);
                  },
                ),
                const SizedBox(height: 24 + 24),
                ValueListenableBuilder(
                  valueListenable: Client.hobbiesCache,
                  builder: (context, hobbies, child) {
                    if (hobbies.isEmpty) return Hobbies.skeleton(context);
                    return Hobbies(hobbies: hobbies);
                  },
                ),
                const SizedBox(height: 24 + 24),
                Text(
                  'Artikler',
                  style: OnlineTheme.header(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder(
                  valueListenable: Client.articlesCache,
                  builder: (context, articles, child) {
                    if (articles.isEmpty) return Center(child: ArticleCarousel.skeleton(context));
                    return Center(child: ArticleCarousel(articles: articles.values.take(5).toList()));
                  },
                ),
                const SizedBox(height: 24 + 24),
                AnimatedButton(
                  onTap: () {
                    context.go('/info');
                  },
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: theme.primaryBg,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.fromBorderSide(BorderSide(color: theme.primary, width: 2)),
                      ),
                      child: Text(
                        'Om Online-Appen',
                        style: OnlineTheme.textStyle(
                          weight: 5,
                          color: theme.primaryFg,
                        ),
                      ),
                    );
                  },
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
