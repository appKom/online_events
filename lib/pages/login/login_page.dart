import 'package:flutter/material.dart';
import '/pages/login/auth_web_view_page.dart';

import 'package:online_events/theme/theme.dart';
import '/components/online_scaffold.dart';
import '/components/animated_button.dart';
import '/components/online_header.dart';

class LoginPage extends StaticPage {
  const LoginPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    final headerStyle = OnlineTheme.textStyle(
      size: 20,
      weight: 7,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logg Inn', style: headerStyle),
            const SizedBox(height: 24),
            AnimatedButton(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginWebView(),
                ));
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  height: OnlineTheme.buttonHeight,
                  decoration: BoxDecoration(
                    gradient: OnlineTheme.greenGradient,
                    borderRadius: OnlineTheme.buttonRadius,
                  ),
                  child: Center(
                    child: Text(
                      'Logg Inn med Online',
                      style: OnlineTheme.textStyle(),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
