import 'package:flutter/material.dart';

import '../../components/online_header.dart';
import '../../components/online_scaffold.dart';
import 'pixel.dart';

class DummyDisplay2 extends StaticPage {
  const DummyDisplay2({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const PixelPage();
  }
}
