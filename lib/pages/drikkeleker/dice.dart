import 'dart:math';
import 'package:flutter/material.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/theme/theme.dart';

class DicePage extends StaticPage {
  const DicePage({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const DiceHomePage();
  }
}

class DiceHomePage extends StatefulWidget {
  const DiceHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DiceHomePageState createState() => _DiceHomePageState();
}

class _DiceHomePageState extends State<DiceHomePage>
    with SingleTickerProviderStateMixin {
  int diceRoll = 1;
  late AnimationController _animationController;
  late Animation _animation;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = IntTween(begin: 1, end: 6).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {
          diceRoll = _random.nextInt(6) + 1;
        });
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void rollDice() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: OnlineHeader.height(context)),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              children: [
                InkWell(
                  onTap: rollDice,
                  child:
                Image.asset(
                  'assets/images/dice$diceRoll.png',
                  width: 300,
                  height: 300,
                ),
                ),
                Text(
                  'Roll result: $diceRoll',
                  style: OnlineTheme.textStyle(),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        // ElevatedButton(
        //   onPressed: rollDice,
        //   child: const Text('Roll the dice'),
        // ),
      ],
    );
  }
}
