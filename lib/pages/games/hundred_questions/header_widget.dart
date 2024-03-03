import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../theme/theme.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(26.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Hundre Spørsmål",
          style: TextStyle(
              color: OnlineTheme.hundredTitleTextColor,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              fontFamily: 'Avenir'),
          textAlign: TextAlign.left,
        ),
      ]),
    );
  }
}
