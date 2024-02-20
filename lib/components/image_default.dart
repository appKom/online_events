import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageDefault extends StatelessWidget {
  const ImageDefault({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SvgPicture.asset(
        'assets/svg/online_hvit_o.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}
