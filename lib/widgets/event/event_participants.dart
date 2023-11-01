import 'package:flutter/material.dart';
import 'package:online_events/theme.dart';

class EventParticipants extends StatelessWidget {
  const EventParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 10), // Add space between icon and text
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: OnlineTheme.blue1, // Blue background for the icon
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
          const SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Venteliste',
                  style: OnlineTheme.eventCardParticipantsHeader,
                  overflow: TextOverflow.visible,
                ),
                Center(
                  child: Expanded(child: Text('10/10', style: OnlineTheme.eventCardDue)),
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
          const SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1-3. Klasse',
                  style: OnlineTheme.eventCardParticipantsHeader,
                  overflow: TextOverflow.visible,
                ),
                Center(
                  child: Expanded(child: Text('10/10', style: OnlineTheme.eventCardDue)),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: OnlineTheme.gray8,
            margin: const EdgeInsets.symmetric(horizontal: 10),
          ),
          const SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '3-5. Klasse',
                  style: OnlineTheme.eventCardParticipantsHeader,
                  overflow: TextOverflow.visible,
                ),
                // Center text
                Center(
                  child: Expanded(child: Text('10/10', style: OnlineTheme.eventCardDue)),
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
                Expanded(child: Text('')),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
