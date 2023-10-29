import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/bedpress.dart';
import 'package:online_events/pages/upcoming_events/profile_button.dart';

import 'upcoming_events.dart';
import '/theme.dart';

class UpcomingEventsPage extends StatelessWidget {
  const UpcomingEventsPage({super.key});

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
                SvgPicture.asset(
                  'assets/header.svg',
                  height: 36,
                  fit: BoxFit.fitHeight,
                ),
                const ProfileButton()
              ],
            ),
            const SizedBox(height: 60),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        color: OnlineTheme.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 276,
                      child: UpcomingEventsList(
                        models: testModels,
                      ),
                    ),
                    Bedpress(
                      models: bedpressModels,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
