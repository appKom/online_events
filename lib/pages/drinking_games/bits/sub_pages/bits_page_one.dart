import 'package:flutter/material.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/pages/drinking_games/bits/bits_home_page.dart';
import 'package:online_events/pages/drinking_games/bits/sub_pages/bits_page_two.dart';
import 'package:online_events/services/page_navigator.dart';
import 'package:online_events/theme/theme.dart';
// Import other pages if necessary

class BitsPageOne extends ScrollablePage {
  const BitsPageOne({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    return Container(
      color: OnlineTheme.pink1,
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
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: OnlineHeader.height(context) + 40),
                    const Text(
                      'Pekelek',
                      style: OnlineTheme.eventHeader,
                    ),
                    const SizedBox(height: 20),
                    const ClipRRect(child: SizedBox(height: 80)),
                    const Positioned(
                      child: Text(
                        'Pek på den i rommet som har brukt en sjekkereplikk relatert til informatikk',
                        style: OnlineTheme.eventListHeader,
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

  @override
  Widget content(BuildContext context) {
    // Properly implement the content method or make sure it's not called if not needed.
    return Container(); // Return an empty Container or actual content if available
  }
}

// Ensure that LeftPage and RightPage are properly defined Flutter widgets.