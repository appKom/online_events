import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';

class SpinLine extends StatefulWidget {
  const SpinLine({super.key});

  @override
  SpinLineState createState() => SpinLineState();
}

class SpinLineState extends State<SpinLine>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  final random = Random();

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 0),
    );


    animation = Tween<double>(begin: 0, end: 2 * pi).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void startSpinning() {
    int randomDuration =
        5 + random.nextInt(6); 
    double randomEndRotation = 2 *
        pi *
        (5 + random.nextDouble()); 

    controller.duration = Duration(seconds: randomDuration);
    animation =
        Tween<double>(begin: controller.value * 2 * pi, end: randomEndRotation)
            .animate(controller)
          ..addListener(() {
            setState(() {});
          });
    controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedButton(onTap: () {
        if (!controller.isAnimating) {
          startSpinning();
        }
      }, childBuilder: (context, hover, pointerDown) {
        return Transform.rotate(
          angle: animation.value,
          child: SvgPicture.asset('assets/svg/online_hvit_o.svg', height: 300),
        );
      }),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
