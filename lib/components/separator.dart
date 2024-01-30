import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  const Separator({super.key, this.margin = 0, this.length, this.axis = Axis.horizontal});

  final double margin;
  final double? length;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final h = axis == Axis.horizontal;
    return Container(
      height: h ? 1 : length,
      width: !h ? 1 : length,
      margin: EdgeInsets.symmetric(vertical: h ? margin : 0, horizontal: !h ? margin : 0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: h ? Alignment.centerLeft : Alignment.bottomCenter,
          end: h ? Alignment.centerRight : Alignment.topCenter,
          colors: const [
            Color(0xFF000212),
            Color(0xFF2E3440),
            Color(0xFF000212),
          ],
        ),
      ),
    );
  }
}
