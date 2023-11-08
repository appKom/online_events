import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/pages/home/promoted_article.dart';
import '/pages/home/profile_button.dart';
import '/services/app_navigator.dart';
import '/pages/home/event_card.dart';
import '../events/events_page.dart';
import '/pages/home/bedpress.dart';
import '../../components/online_scaffold.dart';
import '../../theme/theme.dart';
import '/main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final style = OnlineTheme.textStyle(weight: 5, size: 12);

    return OnlineScaffold(
      header: const ProfileButton(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PromotedArticle(),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          SizedBox(
            height: 15,
            child: Center(
              child: Text(
                'KOMMENDE ARRANGEMENTER',
                style: style,
              ),
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
                    return const EventsPage();
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
                  style: style,
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
          const SizedBox(height: 75),
        ],
      ),
    );
  }
}
