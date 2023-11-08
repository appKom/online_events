import 'package:flutter/material.dart';

import '/components/online_scaffold.dart';
import '/services/app_navigator.dart';
import '/pages/home/home_page.dart';
import '/theme/theme.dart';

class EmailSentPage extends StaticPage {
  const EmailSentPage({super.key});

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Material(
      color: OnlineTheme.background,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 17),
            const SizedBox(height: 60),
            Container(
              width: 300,
              height: 330,
              padding: const EdgeInsets.only(bottom: 20),
              margin: const EdgeInsets.only(right: 20),
              child: Stack(
                children: [
                  const Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: 111,
                      child: Text(
                        'An Email has been sent to you',
                        style: OnlineTheme.loginPageHeader,
                      )),
                  Positioned(
                    left: 0,
                    right: 15,
                    top: 50,
                    height: 65,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to another page when the red box is tapped
                        PageNavigator.navigateTo(const HomePage());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: OnlineTheme.gray14,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            'Return to main page',
                            style: OnlineTheme.logInnPageButton,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
