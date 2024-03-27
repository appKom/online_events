import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:online/pages/login/auth_web_view_page.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/pages/profile/profile_page.dart';
import '/services/app_navigator.dart';
import '/services/authenticator.dart';
import '/theme/theme.dart';

final ValueNotifier<bool> acceptedPrivacy = ValueNotifier(false);

Future<void> appTrackingPermission(bool isIos) async {
  if (!isIos) {
    acceptedPrivacy.value = true;
    return;
  }
  final status = await AppTrackingTransparency.requestTrackingAuthorization();

  acceptedPrivacy.value = status == TrackingStatus.authorized;
}

class LoginPage extends StaticPage {
  const LoginPage({super.key});

  @override
  Widget content(BuildContext context) {
    final padding =
        MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return FutureBuilder(
      future: appTrackingPermission(isIos),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return const IgnorePointer();

        return Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Logg inn med Online', style: OnlineTheme.header()),
              const SizedBox(height: 24),
              AnimatedButton(
                onTap: login,
                childBuilder: (context, hover, pointerDown) {
                  return Container(
                    height: OnlineTheme.buttonHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: OnlineTheme.green.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(5),
                      border: const Border.fromBorderSide(
                          BorderSide(color: OnlineTheme.green, width: 2)),
                    ),
                    child: Text(
                      'Logg Inn',
                      style: OnlineTheme.textStyle(
                          color: OnlineTheme.green, weight: 5),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  Future login() async {
    if (Platform.isAndroid) {
      AppNavigator.replaceWithPage(LoginWebView());
    }

    if (Platform.isIOS) {
      final response = await Authenticator.login();

      if (response != null) {
        AppNavigator.replaceWithPage(const ProfilePage());
      }
    }
  }
}
