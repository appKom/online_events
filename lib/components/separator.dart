import 'package:flutter/material.dart';
import 'package:online/theme/theme.dart';

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
      color: OnlineTheme.current.border,
    );
  }
}
