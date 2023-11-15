import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';

class SpinLine extends StatefulWidget {
  const SpinLine({super.key});

  @override
  SpinLineState createState() => SpinLineState();
}

class SpinLineState extends State<SpinLine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1), // Decrease duration to speed up rotation
      vsync: this,
    )..repeat(); // This will cause the animation to repeat indefinitely
  }

  @override
  void dispose() {
    _controller.dispose(); // Don't forget to dispose of the controller
    super.dispose();
  }

  void stopAnimationAfterDelay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: 
      AnimatedButton(childBuilder: (context, hover, pointerDown){
      return GestureDetector( // Wrap with GestureDetector to handle taps
        onTap: stopAnimationAfterDelay, // Call the method to stop the animation after delay
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller), // Defines the rotation
          child: SvgPicture.asset('assets/svg/online_hvit_o.svg', height: 300),
        ),
      );
      },
      ),
    );
  }
}