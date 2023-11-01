import 'package:flutter/material.dart';
import 'package:online_events/theme.dart';

class EventLocation extends StatelessWidget {
  const EventLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 20),
      height: 65,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: OnlineTheme.blue1, // Blue background for the icon
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.location_on_outlined,
                  size: 20, // Adjust the size of the icon as needed
                  color: OnlineTheme.white, // White icon color
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Portugal, Ericeria',
                style: OnlineTheme.eventCardLocation,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
