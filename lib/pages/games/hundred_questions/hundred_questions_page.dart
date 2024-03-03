import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:online/pages/games/hundred_questions/hundred_models.dart';

import '../../../theme/theme.dart';
import 'custom_card.dart';
import 'header_widget.dart';

class HundredQuestionsInfo extends StatelessWidget {
  const HundredQuestionsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnlineTheme.hundredGradientEndColor,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  OnlineTheme.hundredGradientStartColor,
                  OnlineTheme.hundredGradientEndColor
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.9])),
        child: SafeArea(
            child: Column(
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            const HeaderWidget(),
            SizedBox(
              height: 500,
              child: Swiper(
                itemCount: hundredInfo.length,
                itemWidth: MediaQuery.of(context).size.width,
                itemHeight: MediaQuery.of(context).size.height,
                layout: SwiperLayout.TINDER,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          CustomCard(
                            name: hundredInfo[index].question,
                            position: hundredInfo[index].position,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        )),
      ),
    );
  }
}
