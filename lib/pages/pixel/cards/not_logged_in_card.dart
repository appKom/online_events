import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/components/online_header.dart';
import '/pages/login/terms_of_service.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

class NotLoggedInCard extends StatelessWidget {
  const NotLoggedInCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      AppNavigator.navigateToPage(const TermsOfServicePage());
    }

    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);
    return Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: OnlineHeader.height(context)),
            Center(
              child: Text(
                'Du må være inlogget for å se Pixel',
                style: OnlineTheme.textStyle(),
              ),
            ),
            const SizedBox(
              height: 120,
            ),
            AnimatedButton(
                onTap: onPressed,
                childBuilder: (context, hover, pointerDown) {
                  return Container(
                    height: OnlineTheme.buttonHeight,
                    decoration: BoxDecoration(
                      gradient: OnlineTheme.greenGradient,
                      borderRadius: OnlineTheme.buttonRadius,
                    ),
                    child: Center(
                      child: Text(
                        'Logg Inn',
                        style: OnlineTheme.textStyle(weight: 5),
                      ),
                    ),
                  );
                })
          ],
        ));
  }
}
