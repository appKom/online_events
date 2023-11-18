import 'package:flutter/material.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/theme/theme.dart';

class EventParticipants extends StatelessWidget {
  const EventParticipants({super.key, required this.model});

  final EventModel model;

  String peopleToString() {
    if (model.maxCapacity == null) return 'Ubegrenset';

    return '${model.numberOfSeatsTaken}/${model.maxCapacity}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10), // Add space between icon and text
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: OnlineTheme.purpleGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.people_alt_outlined,
                    size: 20, // Adjust the size of the icon as needed
                    color: OnlineTheme.white, // White icon color
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Venteliste',
                    style: OnlineTheme.textStyle(size: 12, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  Center(
                    child: Text(
                      '0/10',
                      style: OnlineTheme.textStyle(size: 14, height: 1.5, color: OnlineTheme.gray11, weight: 5),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: OnlineTheme.gray8,
              margin: const EdgeInsets.symmetric(horizontal: 14),
            ),
            SizedBox(
              width: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Påmeldte',
                    style: OnlineTheme.textStyle(size: 12, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  Center(
                    child: Text(
                      peopleToString(),
                      style: OnlineTheme.textStyle(size: 14, height: 1.5, color: OnlineTheme.gray11, weight: 5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                    child: Icon(
                      size: 10,
                      Icons.arrow_forward_ios_outlined,
                      color: OnlineTheme.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
