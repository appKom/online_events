import 'package:flutter/material.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/pages/events/my_events_page_loggedin.dart';

import '/components/online_scaffold.dart';
import '/pages/loading/loading_page.dart';

class MyEventsPageLoggedInDisplay extends StaticPage {
  const MyEventsPageLoggedInDisplay({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const MyEventsPageLoggedIn();
  }
}
