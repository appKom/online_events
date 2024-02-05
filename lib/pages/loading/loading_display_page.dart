import 'package:flutter/material.dart';

import '/components/online_scaffold.dart';
import '/pages/loading/loading_page.dart';

class LoadingPageDisplay extends StaticPage {
  const LoadingPageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Padding(
      padding: padding,
      child: const LoadingPage(),
    );
  }
}
