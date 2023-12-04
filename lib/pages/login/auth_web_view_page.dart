import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import 'package:online_events/services/app_navigator.dart';
import 'auth_service.dart';

class LoginWebView extends StatefulWidget {
  const LoginWebView({super.key}); // Modify the constructor

  @override
  LoginWebViewState createState() => LoginWebViewState();
}

class LoginWebViewState extends State<LoginWebView> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(AuthService.authorizationUrl)),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) async {
          if (url.toString().startsWith(AuthService.redirectUri)) {
            final code = Uri.parse(url.toString()).queryParameters['code'];
            if (code != null) {
              print('code: $code');
              final tokenData = await AuthService.exchangeCodeForToken(code);
              if (tokenData != null) {
                // Handle successful login, e.g., navigate to a new screen with the token data
                PageNavigator.navigateTo(ProfilePage(tokenData: tokenData));
                print('sucsess?');
                // You might also want to close the WebView here
              } else {
                // Handle error
                print('fuck');
              }
            }
          }
        },
      ),
    );
  }
}