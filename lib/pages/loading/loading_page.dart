import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/online_scaffold.dart';

class LoadingPage extends StaticPage {
  const LoadingPage({super.key});

  @override
  Widget content(BuildContext context) {
    return Center( // Use Center widget to center the content
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Center the column horizontally
        children: [
          SvgPicture.asset('assets/svg/online_hvit_o.svg', height: 350,)
        ],
      ),
    ); // TODO: Pulsing Online Logo
  }
}