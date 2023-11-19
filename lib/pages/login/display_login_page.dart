import 'package:flutter/material.dart';
import 'package:online_events/pages/login/login_page.dart';

import '/components/online_scaffold.dart';
import '/pages/loading/loading_page.dart';

class LoginPageDisplay extends StaticPage {
  const LoginPageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return LoginPage();
  }
}
