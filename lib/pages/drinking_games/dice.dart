import 'dart:math';

import 'package:flutter/material.dart';

import '/theme/theme.dart';
import '/components/animated_button.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';

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

class _DiceHomePageState extends State<DiceHomePage> with SingleTickerProviderStateMixin {
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
        Center(
          child: AnimatedButton(
            onTap: rollDice,
            childBuilder: (context, hover, pointerDown) {
              return CustomPaint(
                painter: DicePainter(repaint: _animation, dice: diceRoll),
                size: const Size.square(300),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class DicePainter extends CustomPainter {
  DicePainter({super.repaint, required this.dice});

  final int dice;

  @override
  void paint(Canvas canvas, Size size) {
    final dimension = min(size.width, size.height);
    final radius = dimension / 10;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = OnlineTheme.white;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, dimension, dimension), Radius.circular(radius)),
      paint,
    );

    paint.color = OnlineTheme.background;

    final center = dimension / 2;
    final inset1 = (dimension / 5) + radius / 2;
    final inset2 = dimension - inset1;

    switch (dice) {
      case 1:
        canvas.drawCircle(Offset(center, center), radius, paint);
        break;
      case 2:
        canvas.drawCircle(Offset(inset1, inset2), radius, paint);
        canvas.drawCircle(Offset(inset2, inset1), radius, paint);
        break;
      case 3:
        canvas.drawCircle(Offset(center, center), radius, paint);
        canvas.drawCircle(Offset(inset1, inset2), radius, paint);
        canvas.drawCircle(Offset(inset2, inset1), radius, paint);
        break;
      case 4:
        canvas.drawCircle(Offset(inset1, inset1), radius, paint);
        canvas.drawCircle(Offset(inset2, inset1), radius, paint);
        canvas.drawCircle(Offset(inset1, inset2), radius, paint);
        canvas.drawCircle(Offset(inset2, inset2), radius, paint);
      case 5:
        canvas.drawCircle(Offset(center, center), radius, paint);
        canvas.drawCircle(Offset(inset1, inset1), radius, paint);
        canvas.drawCircle(Offset(inset2, inset1), radius, paint);
        canvas.drawCircle(Offset(inset1, inset2), radius, paint);
        canvas.drawCircle(Offset(inset2, inset2), radius, paint);
      default:
        canvas.drawCircle(Offset(inset1, inset1), radius, paint);
        canvas.drawCircle(Offset(inset1, center), radius, paint);
        canvas.drawCircle(Offset(inset1, inset2), radius, paint);
        canvas.drawCircle(Offset(inset2, inset1), radius, paint);
        canvas.drawCircle(Offset(inset2, center), radius, paint);
        canvas.drawCircle(Offset(inset2, inset2), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
