import 'package:flutter/cupertino.dart';
import 'package:online_events/pages/article/article_page.dart';
import '../../services/page_navigator.dart';
import '../../theme/theme.dart';

class PromotedArticle extends StatelessWidget {
  const PromotedArticle({super.key});

  @override
  Widget build(BuildContext context) {
    const date = '26.6.2023';
    const timeToRead = '5 min';

    return SizedBox(
      width: 340,
      height: 222,
      child: GestureDetector(
        onTap: () => PageNavigator.navigateTo(const ArticlePage()),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/fadderuka2.png',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: Container(color: OnlineTheme.gray13)),
                    Positioned(
                      left: 20,
                      bottom: 60,
                      child: Text(
                        'Fadderuka 2023',
                        style: OnlineTheme.textStyle(weight: 5),
                      ),
                    ),
                    Positioned(
                      bottom: 42,
                      left: 20,
                      child: Text(
                        'Isabelle Nordin, Linn Grotnes',
                        style: OnlineTheme.textStyle(
                          size: 14,
                          weight: 5,
                          color: OnlineTheme.gray9,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 20,
                      child: Text(
                        '$date • $timeToRead å lese',
                        style: OnlineTheme.textStyle(
                          size: 14,
                          weight: 5,
                          color: OnlineTheme.gray9,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
