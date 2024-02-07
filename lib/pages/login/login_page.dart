import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/pages/login/terms_of_service.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

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
      backgroundColor: OnlineTheme.background,
      body: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Logg inn med Online', style: headerStyle),
            const SizedBox(height: 24),
            AnimatedButton(
              onTap: () {
                AppNavigator.navigateToPage(const TermsOfServicePage());
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  height: OnlineTheme.buttonHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: OnlineTheme.green.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5),
                    border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.green, width: 2)),
                  ),
                  child: Text(
                    'Logg Inn',
                    style: OnlineTheme.textStyle(color: OnlineTheme.green, weight: 5),
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
