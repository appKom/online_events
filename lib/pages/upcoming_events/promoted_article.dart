import 'package:flutter/material.dart';

import '/theme.dart';

class PromotedArticle extends StatelessWidget {
  const PromotedArticle({super.key});

  @override
  Widget build(BuildContext context) {
    const date = '26.6.2023';
    const timeToRead = '5 min';

    return SizedBox(
      width: 340,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/fadderuka2.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(color: OnlineTheme.gray13),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 60,
                    child: Text(
                      'Fadderuka 2023',
                      style: OnlineTheme.promotedArticleText.copyWith(color: OnlineTheme.white),
                    ),
                  ),
                  Positioned(
                    bottom: 42,
                    left: 20,
                    child: Text(
                      'Isabelle Nordin, Linn Zhu Yu Grotnes',
                      style: OnlineTheme.promotedArticleAuthor.copyWith(color: OnlineTheme.gray9),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 20,
                    child: Text(
                      '$date • $timeToRead å lese',
                      style: OnlineTheme.promotedArticleDate.copyWith(color: OnlineTheme.gray9),
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
