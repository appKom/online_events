import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:online/components/animated_button.dart';
import 'package:online/services/app_navigator.dart';
import 'package:online/theme/themed_icon.dart';

import '/components/online_scaffold.dart';
import '/theme/theme.dart';
import 'custom_card.dart';
import 'questions.dart';

class HundredQuestionsInfo extends StaticPage {
  HundredQuestionsInfo({super.key});

  final controller = SwiperController();

  Future onTap(int idnex) async {
    await controller.previous();
  }

  @override
  Widget content(BuildContext context) {
    List<String> shuffledQuestions = List.from(questions)..shuffle();

    return Container(
      padding: MediaQuery.of(context).padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [OnlineTheme.hundredGradientStartColor, OnlineTheme.hundredGradientEndColor],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.9],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Hundre Spørsmål",
            style: OnlineTheme.textStyle(
              color: OnlineTheme.hundredTitleTextColor,
              size: 30,
              weight: 7,
            ),
          ),
          SizedBox(
            height: 430,
            child: Swiper(
              onTap: onTap,
              itemCount: shuffledQuestions.length,
              itemWidth: MediaQuery.of(context).size.width,
              itemHeight: MediaQuery.of(context).size.height,
              index: shuffledQuestions.length - 1,
              allowImplicitScrolling: true,
              loop: false,
              layout: SwiperLayout.TINDER,
              controller: controller,
              itemBuilder: (context, index) {
                return Center(
                  child: CustomCard(
                    name: shuffledQuestions[index],
                    index: shuffledQuestions.length - index,
                  ),
                );
              },
            ),
          ),
          AnimatedButton(
            onTap: AppNavigator.pop,
            scale: 0.9,
            childBuilder: (context, hover, pointerDown) {
              return ThemedIcon(
                icon: IconType.cross,
                size: 24,
              );
            },
          )
        ],
      ),
    );
  }
}
