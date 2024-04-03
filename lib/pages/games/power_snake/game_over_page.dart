import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class GameOverPage extends StatefulWidget {
  const GameOverPage({super.key});

  @override
  GameOverPageState createState() => GameOverPageState();
}

class GameOverPageState extends State<GameOverPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Game Over!',
          style: OnlineTheme.textStyle(),
        )
      ],
    );
  }
}
