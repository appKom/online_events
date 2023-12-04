import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:online_events/main.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import 'package:online_events/services/app_navigator.dart';
import 'auth_service.dart';

class LoginWebView extends StatefulWidget {
  const LoginWebView({super.key});

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
              final tokenData = await AuthService.exchangeCodeForToken(code);
              if (tokenData != null) {
                // Navigate to the ProfilePage with the token data
                PageNavigator.navigateTo(ProfilePage(tokenData: tokenData));
                
                setState(() {
                  loggedIn = true;
                });
                // Close the WebView by popping the current route
                Navigator.pop(context);
              } else {
                // Handle error
                // Optionally, show an error message or take other appropriate actions
              }
            }
          }
        },
      ),
    );
  }
}