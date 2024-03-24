import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/models/event_model.dart';
import '../events/events_page.dart';
import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart';
import '/pages/home/event_card.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'article_carousel.dart';
import 'bedpres.dart';
import 'info_page.dart';

class HomePage extends ScrollablePage {
  const HomePage({super.key});
  @override
  Widget content(BuildContext context) {
    final padding =
        MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

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
                final tommorow = DateTime.now().add(Duration(days: 1));
                final futureEvents = eventSet.where((event) {
                  final eventDate = DateTime.parse(event.startDate);
                  return eventDate.isAfter(tommorow);
                }).toList();

                if (futureEvents.isEmpty) {
                  return Column(
                    children: List.generate(4, (_) => EventCard.skeleton()),
                  );
                }

                return SizedBox(
                  height: 400,
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
          const SizedBox(height: 24 + 24),
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
              if (articles.isEmpty)
                return Center(child: ArticleCarousel.skeleton(context));
              return Center(
                  child: ArticleCarousel(articles: articles.take(3).toList()));
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
                  color: OnlineTheme.yellow.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5.0),
                  border: const Border.fromBorderSide(
                      BorderSide(color: OnlineTheme.yellow, width: 2)),
                ),
                child: Text(
                  'Om Online-Appen',
                  style: OnlineTheme.textStyle(
                    weight: 5,
                    color: OnlineTheme.yellow,
                  ),
                ),
              );
            },
          ),
          // const SizedBox(height: 24),
          // AnimatedButton(
          //   onTap: () async {
          //     final events = await Client.getAttendanceEvents(userId: Client.userCache.value!.id, pageCount: 2);

          //     for (final event in events) {
          //       print('${event.id}: ${event.timestamp}');
          //     }

          //     print(events.length);
          //   },
          //   childBuilder: (context, hover, pointerDown) {
          //     return Container(
          //       height: 40,
          //       alignment: Alignment.center,
          //       decoration: BoxDecoration(
          //         color: OnlineTheme.yellow.withOpacity(0.4),
          //         borderRadius: BorderRadius.circular(5.0),
          //         border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.yellow, width: 2)),
          //       ),
          //       child: Text(
          //         'Test',
          //         style: OnlineTheme.textStyle(
          //           weight: 5,
          //           color: OnlineTheme.yellow,
          //         ),
          //       ),
          //     );
          //   },
          // ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
