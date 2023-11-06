import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:online_events/pages/home/profile_button.dart';
import 'package:online_events/pages/home/home_page.dart';
import 'package:online_events/theme.dart';

class EmailSentPage extends StatelessWidget {
  const EmailSentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Material(
      color: OnlineTheme.background,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 17),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to another page when the SVG image is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()), // Replace with your page class
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/header.svg',
                    height: 36,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const ProfileButton()
              ],
            ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()), // Replace with the page you want to navigate to
                        );
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
