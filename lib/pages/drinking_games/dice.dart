import 'dart:math';

import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/theme/theme.dart';

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
  final _random = Random();

  int _step = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animationController.addListener(() {
      final t = Curves.easeOut.transform(_animationController.value);

      final i = (t * 5).floor();

      if (i > _step) {
        setState(() {
          _step = i;
          diceRoll = _random.nextInt(6) + 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void rollDice() {
    _animationController.reset();
    _step = 0;
    _animationController.duration = Duration(milliseconds: 250 + Random().nextInt(750));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SizedBox.square(
            dimension: 200,
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: pi * 2 * Curves.decelerate.transform(_animationController.value),
                  child: AnimatedButton(
                    scale: 0.8,
                    onTap: rollDice,
                    childBuilder: (context, hover, pointerDown) {
                      return CustomPaint(
                        painter: DicePainter(repaint: _animationController, dice: diceRoll),
                        size: const Size.square(200),
                      );
                    },
                  ),
                );
              },
              // child: AnimatedButton(
              //   onTap: rollDice,
              //   childBuilder: (context, hover, pointerDown) {
              //     return CustomPaint(
              //       painter: DicePainter(repaint: _animation, dice: diceRoll),
              //       size: const Size.square(200),
              //     );
              //   },
              // ),
            ),
          ),
        ),
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
        break;
      case 5:
        canvas.drawCircle(Offset(center, center), radius, paint);
        canvas.drawCircle(Offset(inset1, inset1), radius, paint);
        canvas.drawCircle(Offset(inset2, inset1), radius, paint);
        canvas.drawCircle(Offset(inset1, inset2), radius, paint);
        canvas.drawCircle(Offset(inset2, inset2), radius, paint);
        break;
      default:
        canvas.drawCircle(Offset(inset1, inset1), radius, paint);
        canvas.drawCircle(Offset(inset1, center), radius, paint);
        canvas.drawCircle(Offset(inset1, inset2), radius, paint);
        canvas.drawCircle(Offset(inset2, inset1), radius, paint);
        canvas.drawCircle(Offset(inset2, center), radius, paint);
        canvas.drawCircle(Offset(inset2, inset2), radius, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
