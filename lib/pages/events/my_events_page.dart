import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/pages/login/login_page.dart';
import 'package:online_events/pages/profile/display_profile_page.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import 'package:online_events/services/page_navigator.dart';

import '../home/event_card.dart';
import '../../theme/theme.dart';
import '/main.dart';

class MyEventsPage extends ScrollablePage {
  const MyEventsPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    final style = OnlineTheme.textStyle(size: 20, weight: 7);
    void onPressed() {
    if (loggedIn) {
      PageNavigator.navigateTo(const ProfilePageDisplay());
    } else {
      PageNavigator.navigateTo(LoginPage());
    }
  }

    if (loggedIn) {
      return Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: OnlineHeader.height(context) + 40),
            Center(
              child: Text(
                'Mine Arrangementer',
                style: style,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 111 * 1,
              child: ListView.builder(
                itemCount: 6,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (c, i) => EventCard(
                  model: eventModels[i % 6],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                'Tidligere Arrangementer',
                style: style,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 111 * 6,
              child: ListView.builder(
                itemCount: 6,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (c, i) => EventCard(
                  model: eventModels[i % 6],
                ),
              ),
            ),
            SizedBox(height: Navbar.height(context)),
          ],
        ),
      );
    } else {
      return Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: OnlineHeader.height(context) + 115),
              Center(
                child: Text(
                  'Du må være inlogget for å se dine arrangementer',
                  style: OnlineTheme.textStyle(),
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              AnimatedButton(
                onTap: onPressed,
                childBuilder: (context, hover, pointerDown) {
                return Container(
                  height: OnlineTheme.buttonHeight,
                  decoration: BoxDecoration(
                    gradient: OnlineTheme.greenGradient,
                    borderRadius: OnlineTheme.buttonRadius,
                  ),
                  child: Center(
                    child: Text(
                      'Logg Inn',
                      style: OnlineTheme.textStyle(weight: 5),
                    ),
                  ),
                );
              })
            ],
          ));
    }
  }
}
