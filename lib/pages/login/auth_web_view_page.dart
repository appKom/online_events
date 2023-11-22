import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'auth_service.dart';

class LoginWebView extends StatefulWidget {
  final AuthService authService; // Add this line

  LoginWebView({Key? key, required this.authService}) : super(key: key); // Modify the constructor

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
        initialUrlRequest: URLRequest(url: Uri.parse(widget.authService.authorizationUrl)), // Use authService from the widget
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) async {
          if (url.toString().startsWith(widget.authService.redirectUri)) { // Use authService from the widget
            final code = Uri.parse(url.toString()).queryParameters['code'];
            if (code != null) {
              final tokenData = await widget.authService.exchangeCodeForToken(code); // Use authService from the widget
              if (tokenData != null) {
                // Handle successful login, e.g., navigate to a new screen with the token data
              }
            }
          }
        },
      ),
    );
  }
}