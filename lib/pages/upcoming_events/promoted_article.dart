import 'package:flutter/material.dart';

import '/theme.dart';

class PromotedArticle extends StatelessWidget {
  const PromotedArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 200,
      padding: EdgeInsets.only(bottom: 20),
      margin: const EdgeInsets.only(right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // decoration: const BoxDecoration(
        //   color: OnlineTheme.white,
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(12),
        //   ),
        // ),
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
                  'assets/images/fadderuka.png',
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
                left: 15,
                bottom: 30,
                child: Text(
                  '18',
                  style: OnlineTheme.eventDateNumber.copyWith(color: OnlineTheme.white),
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
              bottom: 15,
              right: 12,
              child: Text(
                '30/50',
                style: OnlineTheme.eventNumberOfPeople.copyWith(color: OnlineTheme.white),
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }
}
