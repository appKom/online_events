import 'package:flutter/material.dart';

import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import 'bits_page_one.dart';
import 'bits_page_three.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';

class BitsPageTwo extends ScrollablePage {
  const BitsPageTwo({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Container(
      color: OnlineTheme.pink1,
      child: Row(
        children: [
          // Left GestureDetector
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to left page
                PageNavigator.navigateTo(const BitsPageOne()); //venstre
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
                  const Text(
                    'Chug eller Sannhet',
                    style: OnlineTheme.eventHeader,
                  ),
                  const SizedBox(height: 20),
                  const ClipRRect(child: SizedBox(height: 80)),
                  const Positioned(
                    child: Text(
                      'Hva er det rareste stedet du har barbert deg?',
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
                PageNavigator.navigateTo(const BitsPageThree()); //høyre
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