import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/pages/event/event_page.dart';

import '/services/page_navigator.dart';
import '../event/event_page2.dart';
import '/pages/home/event_card.dart';
import '/theme/themed_icon.dart';

import '/models/card_event.dart';
import '../../theme/theme.dart';

class Bedpress extends StatelessWidget {
  final List<CardEventModel> models;
  const Bedpress({super.key, required this.models});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Bedriftpresentasjoner',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 333,
          child: ListView.builder(
            itemCount: bedpressModels.length,
            itemBuilder: buildItem,
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }

  Widget? buildItem(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      child: BedpressCard(
        model: models[index],
      ),
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
    return AnimatedButton(
      onPressed: () => PageNavigator.navigateTo(const EventPage()),
      scale: 0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 222,
          color: OnlineTheme.gray13,
          child: Stack(
            children: [
              Positioned.fill(
                bottom: 111,
                child: Image.asset(
                  model.imageSource,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 15,
                top: 222 + 10,
                child: Text(
                  monthToString(),
                  style: OnlineTheme.textStyle(
                    size: 16,
                    weight: 7,
                    color: OnlineTheme.blue2,
                  ),
                ),
              ),
              Positioned(
                right: 15,
                top: 222 + 25,
                child: Text(
                  model.date.day.toString().padLeft(2, '0'),
                  style: OnlineTheme.textStyle(
                    size: 22,
                    weight: 7,
                  ),
                ),
              ),
              Positioned(
                right: 80,
                top: 222 + 10,
                left: 15,
                child: Text(
                  model.name,
                  style: OnlineTheme.textStyle(
                    color: OnlineTheme.gray11,
                    weight: 7,
                  ),
                ),
              ),
              Positioned(
                left: 15,
                bottom: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                  decoration: BoxDecoration(
                    color: OnlineTheme.green2,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    categoryToString(),
                    style: OnlineTheme.textStyle(weight: 5, size: 14),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                right: 12,
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: ThemedIcon(
                        icon: IconType.people,
                        size: 16,
                        color: OnlineTheme.green1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${model.registered}/${model.capacity}',
                      style: OnlineTheme.textStyle(size: 14),
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
