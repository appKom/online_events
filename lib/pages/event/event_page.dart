import 'package:flutter/material.dart';
import 'package:online_events/theme.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 40);

    return Material(
      color: OnlineTheme.background,
      child: Column(
        children: [
          Container(
            color: OnlineTheme.white,
            height: 267,
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 24, left: 40, right: 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Surfetur til Portugal 2023',
                      style: OnlineTheme.eventHeader,
                    ),
                    Text(
                      'Av X-Sport',
                      style: OnlineTheme.eventListSubHeader,
                    ),
                    EventDateCard(),
                    EventParticipants(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EventDateCard extends StatelessWidget {
  const EventDateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 40),
      height: 65,
      decoration: const BoxDecoration(
        color: OnlineTheme.blue1,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(children: [
          const SizedBox(
            width: 27,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                  child: Text(
                    'Sep',
                    style: OnlineTheme.eventListSubHeader,
                    overflow: TextOverflow.visible,
                  ),
                ),
                Expanded(child: Text('24', style: OnlineTheme.eventCardDate)),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 20,
            color: OnlineTheme.gray8,
            margin: const EdgeInsets.symmetric(horizontal: 30),
          ),
        ]),
      ),
    );
  }
}

class EventParticipants extends StatelessWidget {
  const EventParticipants({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 41,
      child: Row(
        children: [
          Container(
            width: 41,
            height: 41,
            decoration: const BoxDecoration(
              color: OnlineTheme.blue1,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Icon(
              Icons.person,
              color: OnlineTheme.orange10,
            ),
          ),
        ],
      ),
    );
  }
}
