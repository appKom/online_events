import 'package:flutter/material.dart';

import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/pages/drinking_games/bits/bits_home_page.dart';
import '/pages/drinking_games/bits/sub_pages/bits_page_two.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';

class BitsPageOne extends StaticPage {
  const BitsPageOne({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    const background = Color.fromARGB(255, 225, 10, 189);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            OnlineTheme.background,
            background,
          ],
        ),
      ),
      child: Row(
        children: [
          // Left GestureDetector
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to left page
                PageNavigator.navigateTo(const BitsHomePage()); //venstre
              },
              child: Container(color: Colors.transparent),
            ),
          ),

          // Main content
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.only(left: padding.left, right: padding.right),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: OnlineHeader.height(context) + 40),
                  Text(
                    'Pekelek',
                    style: OnlineTheme.textStyle(size: 20, weight: 7),
                  ),
                  const SizedBox(height: 20),
                  const ClipRRect(child: SizedBox(height: 80)),
                  Positioned(
                    child: Text(
                      'Pek på den i rommet som har brukt en sjekkereplikk relatert til informatikk',
                      style: OnlineTheme.textStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right GestureDetector
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to right page
                PageNavigator.navigateTo(const BitsPageTwo()); //høyre
              },
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }
}

// Ensure that LeftPage and RightPage are properly defined Flutter widgets.