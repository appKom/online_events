import 'package:flutter/material.dart';

import '../../components/online_header.dart';
import '../../components/online_scaffold.dart';
import 'profile_page.dart';

class DummyDisplay extends StaticPage {
  const DummyDisplay({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const ProfilePage();
  }
}