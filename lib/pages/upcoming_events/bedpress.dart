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
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

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
} //hello

class BedpressCard extends StatelessWidget {
  final CardEventModel model;

  const BedpressCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 222 + 20,
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
              height: 111,
              child: SizedBox(
                // color: Colors.red,
                height: 17,
                child: Image.asset(
                  'assets/images/cake.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                top: 111,
                height: 200,
                child: Container(
                  color: OnlineTheme.gray13,
                )),
            Positioned(
                left: 15,
                bottom: 77,
                child: Text(
                  'Sep',
                  style: OnlineTheme.eventDateMonth.copyWith(color: OnlineTheme.blue2),
                )),
            Positioned(
                left: 15,
                bottom: 45,
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
                    'Sosialt',
                    style: OnlineTheme.eventListHeader.copyWith(color: OnlineTheme.green1, height: 1),
                  ),
                ),
              ),
            ),
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
            
            Positioned(
              right: 48,
              bottom: 15,
              child: SizedBox(
                // color: Colors.red,
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
