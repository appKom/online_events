import 'dart:async';
import 'package:flutter/material.dart';

// Assuming the theme remains the same
import '/theme/theme.dart';

class EventCardCountdown extends StatefulWidget {
  final DateTime eventTime; // Time of the event

  const EventCardCountdown({super.key, required this.eventTime});

  @override
  _EventCardCountdownState createState() => _EventCardCountdownState();
}

class _EventCardCountdownState extends State<EventCardCountdown> {
  late Timer _timer;
  Duration timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    timeLeft = widget.eventTime.difference(DateTime.now());
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
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
    return SizedBox(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          numberColumn(timeLeft.inDays.toString(), "Dager"),
          numberColumn((timeLeft.inHours % 24).toString(), "Timer"),
          numberColumn((timeLeft.inMinutes % 60).toString(), "Minutter"),
          numberColumn((timeLeft.inSeconds % 60).toString(), "Sekunder"),
        ],
      ),
    );
  }

  Widget numberColumn(String number, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          number,
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