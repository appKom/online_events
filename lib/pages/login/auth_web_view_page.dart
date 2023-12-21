import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:online_events/main.dart';
import 'package:online_events/pages/login/auth_service.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import 'package:online_events/services/app_navigator.dart';
import '../../core/client/client.dart';


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
      appBar: AppBar(title: const Text('Login')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(AuthService.authorizationUrl)),
        onWebViewCreated: _onWebViewCreated,
        onLoadStart: _onLoadStart,
      ),
    );
  }

  void _onWebViewCreated(InAppWebViewController controller) {
    webViewController = controller;
  }

  Future<void> _onLoadStart(InAppWebViewController controller, Uri? url) async {
    if (url == null || !url.toString().startsWith(AuthService.redirectUri)) return;

    final code = url.queryParameters['code'];
    if (code == null) {
      print('No authorization code received');
      return;
    }

    try {
      final tokenData = await AuthService.exchangeCodeForToken(code);
      if (tokenData == null) {
        print('Token exchange failed');
        return;
      }

      Client.setAccessToken(tokenData['access_token']);
      setState(() => loggedIn = true);
      PageNavigator.navigateTo(const ProfilePageDisplay());
      Navigator.pop(context);
    } catch (e) {
      print('Error during token exchange: $e');
    }
  }
}