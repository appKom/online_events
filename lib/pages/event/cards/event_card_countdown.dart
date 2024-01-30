import 'dart:async';
import 'package:flutter/material.dart';

// Assuming the theme remains the same
import '/theme/theme.dart';

class EventCardCountdown extends StatefulWidget {
  final DateTime eventTime; // Time of the event

  const EventCardCountdown({super.key, required this.eventTime});

  @override
  EventCardCountdownState createState() => EventCardCountdownState();
}

class EventCardCountdownState extends State<EventCardCountdown> {
  late Timer _timer;
  Duration timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.eventTime.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        timeLeft = widget.eventTime.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = timeLeft.inDays;
    final hours = timeLeft.inHours % 24;
    final minutes = timeLeft.inMinutes % 60;
    final seconds = timeLeft.inSeconds % 60;

    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          numberColumn(days, days == 1 ? 'Dag' : 'Dager'),
          numberColumn(hours, hours == 1 ? 'Time' : 'Timer'),
          numberColumn(minutes, minutes == 1 ? 'Minutt' : 'Minutter'),
          numberColumn(seconds, seconds == 1 ? 'Sekund' : 'Sekunder'),
        ],
      ),
    );
  }

  Widget numberColumn(int number, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          number.toString(),
          style: OnlineTheme.textStyle(
            height: 1,
            weight: 7,
            size: 20,
          ),
        ),
        Text(
          label,
          style: OnlineTheme.textStyle(
            height: 1,
            size: 14,
          ),
        ),
      ],
    );
  }
}
