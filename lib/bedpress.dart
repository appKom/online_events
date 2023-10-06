import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/models/card_event.dart';
import '/models/list_event.dart';
import '/theme.dart';

class Bedpress extends StatelessWidget {
  final List<CardEventModel> models;
  const Bedpress({super.key, required this.models});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

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
    if (index >= models.length) return null;
    return BedpressCard(
      model: models[index],
    );
  }
}//hello

class BedpressCard extends StatelessWidget {
  final CardEventModel model;

  const BedpressCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 222,
      margin: const EdgeInsets.only(right: 20),
      decoration: const BoxDecoration(
        color: OnlineTheme.white,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      // color: OnlineTheme.white,
    );
  }
}

final bedpressModels = [
  CardEventModel(
    name: 'Kakebakekurs med Appkom',
    date: DateTime(2023, 9, 18),
    capacity: 50,
    registered: 30,
    category: EventCategory.sosialt,
  ),
  CardEventModel(
    name: 'Kakebakekurs med Appkom',
    date: DateTime(2023, 9, 18),
    capacity: 50,
    registered: 30,
    category: EventCategory.sosialt,
  ),
  CardEventModel(
    name: 'Kakebakekurs med Appkom',
    date: DateTime(2023, 9, 18),
    capacity: 50,
    registered: 30,
    category: EventCategory.sosialt,
  ),
  CardEventModel(
    name: 'Kakebakekurs med Appkom',
    date: DateTime(2023, 9, 18),
    capacity: 50,
    registered: 30,
    category: EventCategory.sosialt,
  ),
];
