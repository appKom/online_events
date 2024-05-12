import 'package:flutter/material.dart';

import '../events/events_page.dart';
import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart';
import '/core/models/event_model.dart';
import '/pages/home/event_card.dart';
import '/pages/home/hobbies.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'article_carousel.dart';
import 'bedpres.dart';
import 'info_page.dart';

class HomePage extends ScrollablePage {
  const HomePage({super.key});
  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    final theme = OnlineTheme.current;

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
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 24),
            child: ValueListenableBuilder<Set<EventModel>>(
              valueListenable: Client.eventsCache,
              builder: (context, Set<EventModel> eventSet, child) {
                final today = DateTime.now();
                final futureEvents = eventSet.where((event) {
                  final eventDate = DateTime.parse(event.endDate);
                  return eventDate.isAfter(today);
                }).toList();

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
                  AppNavigator.navigateToPage(const EventsPage());
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
          Text('Artikler', style: OnlineTheme.header()),
          const SizedBox(height: 24),
          ValueListenableBuilder(
            valueListenable: Client.articlesCache,
            builder: (context, articles, child) {
              if (articles.isEmpty) return Center(child: ArticleCarousel.skeleton(context));
              return Center(child: ArticleCarousel(articles: articles.take(3).toList()));
            },
          ),
          const SizedBox(height: 24 + 24),
          AnimatedButton(
            onTap: () {
              AppNavigator.navigateToPage(const InfoPage());
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
    );
  }
}
