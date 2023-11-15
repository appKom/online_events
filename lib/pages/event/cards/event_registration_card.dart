import 'package:flutter/material.dart';
import 'package:online_events/theme/theme.dart';

/// This appears to be the row with the width problems
class EventRegistrationCard extends StatelessWidget {
  const EventRegistrationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: 85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Påmeldingsstart',
                    style: OnlineTheme.textStyle(size: 12, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  Center(
                    child: Text(
                      '14.11, 12:00',
                      style: OnlineTheme.textStyle(size: 14, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: OnlineTheme.gray8,
              margin: const EdgeInsets.symmetric(horizontal: 5),
            ),
            SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Påmeldingsslutt',
                    style: OnlineTheme.textStyle(size: 12, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  Center(
                    child: Text(
                      '18.11, 10:00',
                      style: OnlineTheme.textStyle(size: 14, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: OnlineTheme.gray8,
              margin: const EdgeInsets.symmetric(horizontal: 5),
            ),
            SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avmeldingsfrist',
                    style: OnlineTheme.textStyle(size: 12, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  // Center text
                  Center(
                    child: Text(
                      '17.11, 12:00',
                      style: OnlineTheme.textStyle(size: 14, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
