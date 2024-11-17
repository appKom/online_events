import 'dart:async';

import 'package:flutter/material.dart';

import '/pages/event/cards/event_card_countdown.dart';
import '/theme/theme.dart';

class ChristmasCountdown extends StatefulWidget {
  const ChristmasCountdown({super.key});

  @override
  ChristmasCountdownState createState() => ChristmasCountdownState();
}

class ChristmasCountdownState extends State<ChristmasCountdown> {
  final ValueNotifier<bool> isChristmas = ValueNotifier<bool>(false);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final today = DateTime.now();
      final merryChristmas = today.month == 12 && today.day == 24;
      isChristmas.value = merryChristmas;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    isChristmas.dispose();
    super.dispose();
  }

  Widget _background() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/christmas_background_dark.webp',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _merryChristmas() {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          _background(),
          Container(
            padding: OnlineTheme.horizontalPadding,
            decoration: BoxDecoration(
              color: OnlineTheme.current.bg.withOpacity(0.6),
              border: Border(
                bottom: BorderSide(
                  color: OnlineTheme.current.border,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'God Jul!',
                    style: OnlineTheme.header(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _christmasCountdown() {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          _background(),
          Container(
            padding: OnlineTheme.horizontalPadding,
            decoration: BoxDecoration(
              color: OnlineTheme.current.bg.withOpacity(0.6),
              border: Border(
                bottom: BorderSide(
                  color: OnlineTheme.current.border,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hvor lenge er det til Julaften?',
                  style: OnlineTheme.header(),
                ),
                const SizedBox(height: 24),
                EventCardCountdown(eventTime: DateTime(2024, 12, 24)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isChristmas,
      builder: (context, merryChristmas, child) {
        return merryChristmas ? _merryChristmas() : _christmasCountdown();
      },
    );
  }
}
