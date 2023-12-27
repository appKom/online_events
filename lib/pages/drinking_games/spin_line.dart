import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';

class SpinLine extends StatefulWidget {
  const SpinLine({super.key});

  @override
  SpinLineState createState() => SpinLineState();
}

class SpinLineState extends State<SpinLine> {
  double _rotation = 0.0;
  double _startHorizontalDrag = 0.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedButton(
        childBuilder: (context, hover, pointerDown) {
          return GestureDetector(
            onHorizontalDragStart: (details) {
              _startHorizontalDrag = details.localPosition.dx;
            },
            onHorizontalDragUpdate: (details) {
              setState(() {
                double delta = details.localPosition.dx - _startHorizontalDrag;
                _rotation += delta * 0.01; // Adjust the multiplier as needed
              });
            },
            onTap: () {
              // Implement tap functionality if needed
            },
            child: Transform.rotate(
              angle: _rotation,
              child:
                  SvgPicture.asset('assets/svg/online_hvit_o.svg', height: 300),
            ),
          );
        },
      ),
    );
  }
}
