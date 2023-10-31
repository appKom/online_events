import 'package:flutter/material.dart';
import 'package:online_events/pages/article/article_page.dart';

import '/theme.dart';

class PromotedArticle extends StatelessWidget {
  const PromotedArticle({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the Container with GestureDetector
    return GestureDetector(
      onTap: () {
        // Navigate to another page when the stack is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ArticlePage()), // Replace with your page route
        );
      },
      child: Container(
        width: 340,
        height: 200,
        padding: EdgeInsets.only(bottom: 20),
        margin: const EdgeInsets.only(right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 100,
              child: SizedBox(
                // color: Colors.red,
                height: 17,
                child: Image.asset(
                  'assets/images/fadderuka2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: 100,
                height: 200,
                child: Container(
                  color: OnlineTheme.gray13,
                )),
          
            Positioned(
                left: 20,
                bottom: 52,
                child: Text(
                  'Fadderuka 2023',
                  style: OnlineTheme.promotedArticleText.copyWith(color: OnlineTheme.white),
                )),
            Positioned(
                left: 65,
                bottom: 53,
                right: 10,
                top: 130,
                child: Text(
                  'Kakebake kurs med Appkom',
                  style: OnlineTheme.eventBedpressHeader.copyWith(color: OnlineTheme.white),
                )),
            
            // Positioned(
            //     left: 24,
            //     bottom: 15,
            //     // top: 210,
            //     // height: 200,
            //     height: 24,
            //     child: Text(
            //       'Sosialt',
            //       style: OnlineTheme.eventListHeader
            //           .copyWith(color: OnlineTheme.green1),
            //     )),
            Positioned(
              bottom: 34,
              left: 20,
              child: Text(
                'Isabelle Nordin, Linn Zhu Yu Grotnes',
                style: OnlineTheme.promotedArticleAuthor.copyWith(color: OnlineTheme.white),
              ),
            ),

            Positioned(
              bottom: 5,
              left: 20,
              child: Text(
                '26.6.2023',
                style: OnlineTheme.promotedArticleDate.copyWith(color: OnlineTheme.white),
              ),
            ),
            
            
          ],
        ),
      ),
    )
    );
    
  }
}
