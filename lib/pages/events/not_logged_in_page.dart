import 'package:flutter/material.dart';
import 'package:online_events/pages/login/terms_of_service.dart';
import 'package:online_events/services/app_navigator.dart';
import '../../../components/animated_button.dart';
import '../../../components/online_header.dart';
import '/theme/theme.dart';

class NotLoggedInPage extends StatelessWidget {
  const NotLoggedInPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      PageNavigator.navigateTo(const TermsOfServicePage());
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
                'Du må være inlogget for å se dine arrangementer',
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
