import 'package:flutter/material.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import 'package:online_events/components/online_header.dart';
import '/components/online_scaffold.dart';


class ProfilePageDisplay extends StaticPage {
  const ProfilePageDisplay({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }
  @override
  Widget content(BuildContext context) {
    return const ProfilePage();
  }
}
