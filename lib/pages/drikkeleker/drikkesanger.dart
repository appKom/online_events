import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/pages/drikkeleker/lambo.dart';
import 'package:online_events/pages/drikkeleker/nu_klinger.dart';

import '/services/page_navigator.dart';
import '/pages/home/event_card.dart';

import '/models/card_event.dart';
import '../../theme/theme.dart';

class DrikkeSanger extends StatelessWidget {
  final List<CardEventModel> models;
  const DrikkeSanger({super.key, required this.models});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Sanger',
          style: OnlineTheme.eventHeader,
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 250,
          child: ListView.builder(
            itemCount: sangModels.length,
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
      child: SangCard(
        model: models[index],
      ),
    );
  }
}

class SangCard extends StatelessWidget {
  final CardEventModel model;

  const SangCard({super.key, required this.model});

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
      onPressed: () {
        if (model.name == 'Nu Klinger') {
          PageNavigator.navigateTo(const NuKlingerPage()); 
        } else if (model.name == 'Lambo') {
          PageNavigator.navigateTo(const LamboPage());
        }
      },
      scale: 0.9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 222,
          color: OnlineTheme.gray13,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  model.imageSource,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.black.withOpacity(0.5),
                  child: Text(
                    model.name,
                    style: OnlineTheme.eventHeader,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final sangModels = [
  CardEventModel(
      imageSource: 'assets/images/lambo.jpg',
      name: 'Lambo',
      date: DateTime(2023, 12, 5),
      registered: 20,
      capacity: 20,
      category: EventCategory.sosialt),
  CardEventModel(
      imageSource: 'assets/images/nu_klinger.jpg',
      name: 'Nu Klinger',
      date: DateTime(2023, 11, 26),
      registered: 40,
      capacity: 40,
      category: EventCategory.kurs),
];
