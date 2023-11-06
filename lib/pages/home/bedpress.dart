import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/pages/home/event_card.dart';

import '/models/card_event.dart';
import '../../theme/theme.dart';

class Bedpress extends StatelessWidget {
  final List<CardEventModel> models;
  const Bedpress({super.key, required this.models});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 50,
            child: Text(
              'Bedriftpresentasjoner',
              style: OnlineTheme.eventListHeader,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: bedpressModels.length,
              itemBuilder: buildItem,
              scrollDirection: Axis.horizontal,
              // itemExtent: 240 + 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget? buildItem(BuildContext context, int index) {
    return BedpressCard(
      model: models[index],
    );
  }
}

class BedpressCard extends StatelessWidget {
  final CardEventModel model;

  const BedpressCard({super.key, required this.model});

  String categoryToString() {
    final cat = model.category;
    final lowercase = cat.toString().split('.').last;
    return lowercase[0].toUpperCase() + lowercase.substring(1);
  }

  String monthToString() {
    return EventCard.months[model.date.month - 1].substring(0, 3);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 222 + 20,
      padding: const EdgeInsets.only(bottom: 20),
      margin: const EdgeInsets.only(right: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 111,
              child: Image.asset(
                model.imageSource,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 111,
              height: 200,
              child: Container(
                color: OnlineTheme.gray13,
              ),
            ),
            Positioned(
              left: 15,
              bottom: 77,
              child: Text(
                monthToString(),
                style: OnlineTheme.eventDateMonth.copyWith(color: OnlineTheme.blue2),
              ),
            ),
            Positioned(
              left: 15,
              bottom: 45,
              child: Text(
                model.date.day.toString().padLeft(2, '0'),
                style: OnlineTheme.eventDateNumber.copyWith(color: OnlineTheme.white),
              ),
            ),
            Positioned(
              left: 65,
              bottom: 53,
              right: 10,
              top: 130,
              child: Text(
                model.name,
                style: OnlineTheme.eventBedpressHeader.copyWith(color: OnlineTheme.white),
              ),
            ),
            Positioned(
              left: 15,
              right: 160,
              bottom: 15,
              height: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: OnlineTheme.green2,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Center(
                  child: Text(
                    categoryToString(),
                    style: OnlineTheme.eventListHeader.copyWith(color: OnlineTheme.green1, height: 1),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 12,
              child: Text(
                '${model.registered}/${model.capacity}',
                style: OnlineTheme.eventNumberOfPeople.copyWith(color: OnlineTheme.white),
              ),
            ),
            Positioned(
              right: 48,
              bottom: 15,
              child: SizedBox(
                height: 17,
                child: SvgPicture.asset(
                  'assets/icons/people.svg',
                  height: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final bedpressModels = [
  CardEventModel(
      imageSource: 'assets/images/buldring.png',
      name: 'Bedpress i klatreparken',
      date: DateTime(2023, 12, 5),
      registered: 20,
      capacity: 20,
      category: EventCategory.sosialt),
  CardEventModel(
      imageSource: 'assets/images/cake.png',
      name: 'Bedpress og brownies',
      date: DateTime(2023, 11, 26),
      registered: 40,
      capacity: 40,
      category: EventCategory.kurs),
  CardEventModel(
    imageSource: 'assets/images/heart.png',
    name: 'Bedpress med Tinder',
    date: DateTime(2023, 9, 27),
    registered: 5,
    capacity: 5,
    category: EventCategory.kurs,
  ),
];
