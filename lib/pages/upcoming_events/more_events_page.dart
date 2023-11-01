import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/pages/upcoming_events/bedpress.dart';
import 'package:online_events/pages/upcoming_events/my_events_page.dart';
import 'package:online_events/pages/upcoming_events/profile_button.dart';
import 'package:online_events/pages/upcoming_events/promoted_article.dart';
import 'package:online_events/pages/upcoming_events/upcoming_events_page.dart';

import 'upcoming_events.dart';
import '/theme.dart';

class MoreEventsPage extends StatelessWidget {
  const MoreEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnlineScaffold(
      header: const ProfileButton(),
      content: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyEventsPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: OnlineTheme.gray14,
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
              ),
              child: const Text(
                'Gå til mine kommende arrangementer',
                style: OnlineTheme.GoToButton,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 242,
              child: UpcomingEventsList(
                models: testModels,
              ),
            ),
            SizedBox(
              height: 242,
              child: UpcomingEventsList(
                models: testModels,
              ),
            ),
            SizedBox(
              height: 242,
              child: UpcomingEventsList(
                models: testModels,
              ),
            ),
            SizedBox(
              height: 242,
              child: UpcomingEventsList(
                models: testModels,
              ),
            ),
            SizedBox(
              height: 242,
              child: UpcomingEventsList(
                models: testModels,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Online logo, valgfri header og scrollbart innhold med fade
class OnlineScaffold extends StatelessWidget {
  final Widget? header;
  final Widget content;

  const OnlineScaffold({super.key, this.header, required this.content});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UpcomingEventsPage()),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/header.svg',
                    height: 36,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00FFFFFF),
                      Color(0xFFFFFFFF),
                    ],
                    stops: [
                      0.0,
                      0.05,
                    ],
                  ).createShader(bounds);
                },
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      content,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
