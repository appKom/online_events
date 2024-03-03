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
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  OnlineTheme.hundredGradientStartColor,
                  OnlineTheme.hundredGradientEndColor
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.1, 0.9])),
        child: SafeArea(
            child: Column(
          children: <Widget>[
            const HeaderWidget(),
            SizedBox(
              height: 500,
              child: Swiper(
                itemCount: hundredInfo.length,
                itemWidth: MediaQuery.of(context).size.width,
                itemHeight: MediaQuery.of(context).size.height,
                layout: SwiperLayout.TINDER,
                pagination: SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                        color: OnlineTheme.hundredDotColor,
                        activeColor: Colors.white,
                        activeSize: 12,
                        space: 4)),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          CustomCard(
                            name: hundredInfo[index].name,
                          ),
                        ],
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 20),
                      //   child: Image.asset(hundredInfo[index].iconImage),
                      // )
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
