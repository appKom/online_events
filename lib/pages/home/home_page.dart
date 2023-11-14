import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';

import '/pages/home/promoted_article.dart';
import '../../services/page_navigator.dart';
import '/pages/home/event_card.dart';
import '../events/events_page.dart';
import '/pages/home/bedpress.dart';
import '../../components/online_scaffold.dart';
import '../../theme/theme.dart';
import '/main.dart';
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: PromotedArticle(),
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
            child: ListView.builder(
              itemCount: 2,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (c, i) => EventCard(
                model: testModels[i],
              ),
            ),
          ),
          AnimatedButton(
            onTap: () => PageNavigator.navigateTo(const EventsPage()),
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
          Bedpress(
            models: bedpressModels,
          ),
          SizedBox(height: Navbar.height(context) + 24),
        ],
      ),
    );
  }
}
