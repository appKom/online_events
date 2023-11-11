import 'package:flutter/material.dart';
import 'package:online_events/pages/drikkeleker/bits/bits_home_page.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/pages/drikkeleker/dice.dart';
import '/pages/drikkeleker/drikkesanger.dart';
import '/pages/drikkeleker/nu_klinger.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

class DrikkelekerHome extends ScrollablePage {
  const DrikkelekerHome({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: OnlineHeader.height(context) + 40),
            DrikkeSanger(
              models: sangModels,
            ),
            const SizedBox(height: 25),
            const Text(
              'Drikkeleker',
              style: OnlineTheme.eventHeader,
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                PageNavigator.navigateTo(const DicePage());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity, // as wide as the parent allows
                  height: 222, // fixed height
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/diceHeader.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          color: Colors.black.withOpacity(0.5),
                          child: const Text(
                            'Terning',
                            style: OnlineTheme.eventListHeader,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const ClipRRect(child: SizedBox(height: 35)),
            InkWell(
              onTap: () {
                PageNavigator.navigateTo(const BitsHomePage());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity, // as wide as the parent allows
                  height: 222, // fixed height

                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/bits.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0), // Add some padding around the text
                          color: Colors.black.withOpacity(0.5), // Semi-transparent background for the text
                          child: const Text(
                            'Bits',
                            style: OnlineTheme.eventListHeader, // Ensure the text is visible against the background
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const ClipRRect(child: SizedBox(height: 35)),
            InkWell(
              onTap: () {
                PageNavigator.navigateTo(const NuKlingerPage());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity, // as wide as the parent allows
                  height: 222, // fixed height

                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/bytes.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0), // Add some padding around the text
                          color: Colors.black.withOpacity(0.5), // Semi-transparent background for the text
                          child: const Text(
                            'Bytes',
                            style: OnlineTheme.eventListHeader, // Ensure the text is visible against the background
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const ClipRRect(child: SizedBox(height: 115)),
          ],
        ),
      ),
    );
  }

  @override
  Widget content(BuildContext context) {
    // Properly implement the content method or make sure it's not called if not needed.
    return Container(); // Return an empty Container or actual content if available
  }
}
