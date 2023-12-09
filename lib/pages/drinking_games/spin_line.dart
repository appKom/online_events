import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';

import 'package:sensors_plus/sensors_plus.dart';

class SpinLine extends StatefulWidget {
  const SpinLine({super.key});

  @override
  SpinLineState createState() => SpinLineState();
}

class SpinLineState extends State<SpinLine> {
  late double _rotation = 0.0;
  StreamSubscription? _gyroscopeSubscription;

  @override
  void initState() {
    super.initState();
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _rotation += event.y; // Adjust this calculation based on your needs
      });
    });
  }

  @override
  void dispose() {
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedButton(
        childBuilder: (context, hover, pointerDown) {
          return GestureDetector(
            onTap: () {
              // Implement tap functionality if needed
            },
            child: Transform.rotate(
              angle: _rotation,
              child: SvgPicture.asset('assets/svg/online_hvit_o.svg', height: 300),
            ),
          );
        },
      ),
    );
  }
}