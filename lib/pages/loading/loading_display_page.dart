import 'package:flutter/material.dart';

import '/components/online_scaffold.dart';
import '/pages/loading/loading_page.dart';

class LoadingPageDisplay extends StaticPage {
  const LoadingPageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return const LoadingPage();
  }
}
