import 'package:flutter/material.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import 'package:online_events/services/app_navigator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:online_events/pages/login/auth_service.dart'; // Import AuthService

class AuthWebViewPage extends StatefulWidget {
  final String authUrl;
  final AuthService authService; // Add AuthService

  const AuthWebViewPage({Key? key, required this.authUrl, required this.authService}) : super(key: key);

  @override
  _AuthWebViewPageState createState() => _AuthWebViewPageState();
}

class _AuthWebViewPageState extends State<AuthWebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: WebView(
        initialUrl: widget.authUrl,
        javascriptMode: JavascriptMode.unrestricted, // Enable JavaScript
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith(widget.authService.redirectUri)) {
            // Check for the specific redirect URI
            Uri uri = Uri.parse(request.url);
            String? authorizationCode = uri.queryParameters['code'];

            if (authorizationCode != null) {
              widget.authService.exchangeCodeForToken(authorizationCode).then((success) {
                if (success) {
                  PageNavigator.navigateTo(const ProfilePage());
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authentication failed')));
                }
              });
            } else {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Authentication error')));
            }

            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}