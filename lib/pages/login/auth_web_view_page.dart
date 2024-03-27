import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '/main.dart';

import '/core/client/client.dart';
import '/pages/login/auth_service.dart';
import '/pages/profile/profile_page.dart';
import '/services/app_navigator.dart';

class LoginWebView extends StatefulWidget {
  @override
  _LoginWebViewState createState() => _LoginWebViewState();
}

class _LoginWebViewState extends State<LoginWebView> {
  final InAppWebViewController? webViewController = null;
  final CookieManager cookieManager = CookieManager.instance();

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest:
          URLRequest(url: Uri.parse(AuthService.authorizationUrl)),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          useOnLoadResource: true,
        ),
      ),
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        var uri = navigationAction.request.url!;

        if (uri.toString().startsWith(AuthService.redirectUri)) {
          final String? code = uri.queryParameters['code'];
          if (code != null) {
            AuthService.exchangeCodeForToken(code).then((tokens) {
              if (tokens != null) {
                // Navigate to your app's home screen or another relevant screen,
                // passing along the necessary tokens for API calls.
                AppNavigator.replaceWithPage(const ProfilePage());
              } else {
                // Handle login failure or display an error message
                print('Failed to login');
              }
            });
          }
          return NavigationActionPolicy.CANCEL;
        }
        return NavigationActionPolicy.ALLOW;
      },
    );
  }
}
