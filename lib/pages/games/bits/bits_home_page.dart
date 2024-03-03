import 'package:flutter/material.dart';

import '/components/online_scaffold.dart';
import '/pages/games/bits/bits_page.dart';

class BitsHomePage extends StaticPage {
  const BitsHomePage({super.key});

  @override
  Widget content(BuildContext context) {
    return BitsGame();
  }
}
