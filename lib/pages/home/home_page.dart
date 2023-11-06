import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_events/main.dart';
import 'package:online_events/pages/home/event_card.dart';
import 'package:online_events/services/app_navigator.dart';

import '/pages/home/promoted_article.dart';
import '/pages/home/profile_button.dart';
import '/pages/home/bedpress.dart';
import '/online_scaffold.dart';
import 'more_events_page.dart';
import 'upcoming_events.dart';
import '/theme.dart';

class UpcomingEventsPage extends StatelessWidget {
  const UpcomingEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnlineScaffold(
      header: const ProfileButton(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PromotedArticle(),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          const SizedBox(
            height: 15,
            child: Center(
              child: Text('KOMMENDE ARRANGEMENTER', style: OnlineTheme.UpcommingEventstext),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 111 * 2,
            child: ListView.builder(
              itemCount: 2,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (c, i) => EventCard(
                model: testModels[i],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              AppNavigator.navigateToRoute(
                CupertinoPageRoute(
                  builder: (context) {
                    return const MoreEventsPage();
                  },
                  maintainState: false,
                  // fullscreenDialog:
                ),
                additive: true,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'MER',
                  style: OnlineTheme.UpcommingEventstext.copyWith(fontWeight: FontWeight.w500),
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
            ),
          ),
          const SizedBox(height: 10),
          Bedpress(
            models: bedpressModels,
          ),
        ],
      ),
    );
  }
}
