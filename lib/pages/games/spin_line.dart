import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/theme/theme.dart';

import '../../services/app_navigator.dart';
import '/components/animated_button.dart';

class SpinLine extends StatefulWidget {
  const SpinLine({super.key});

  @override
  SpinLineState createState() => SpinLineState();
}

class SpinLineState extends State<SpinLine> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  final random = Random();

  double startRotation = 0;
  double endRotation = 0;
  double rotation = 0;

  Curve randomCurve = Curves.decelerate;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
    );

    controller.addListener(() {
      final t = controller.value;

      final transformed = randomCurve.transform(t);

      rotation = lerpDouble(startRotation, endRotation, transformed)!;
    });
  }

  final curves = [
    Curves.bounceOut,
    Curves.elasticOut,
    Curves.decelerate,
    Curves.decelerate,
    Curves.decelerate,
    Curves.linear,
    Curves.slowMiddle,
    Curves.easeInOutBack,
  ];

  void spin() {
    final randomDuration = 2500 + random.nextInt(2500);

    randomCurve = curves[random.nextInt(curves.length)];
    startRotation = rotation;

    // Has to rotate at least half a rotation and can rotate up to 5 times
    endRotation = startRotation + pi + (8 * pi * random.nextDouble());

    controller.duration = Duration(milliseconds: randomDuration);

    controller.reset();
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    return Container(
      color: OnlineTheme.current.bg,
      child: Padding(
        padding: padding,
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return AnimatedButton(onTap: () {
                    if (!controller.isAnimating) {
                      spin();
                    }
                  }, childBuilder: (context, hover, pointerDown) {
                    return Transform.rotate(
                      angle: rotation,
                      child: SvgPicture.asset(
                        'assets/svg/online_hvit_o.svg',
                        height: 300,
                      ),
                    );
                  });
                },
              ),
            ),
            Positioned(
              top: padding.right,
              right: 0,
              child: AnimatedButton(onTap: () {
                AppNavigator.pop();
              }, childBuilder: (context, hover, pointerDown) {
                return Icon(
                  Icons.close_outlined,
                  color: OnlineTheme.current.fg,
                  size: 32,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
