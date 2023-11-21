import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:online_events/pages/login/auth_service.dart'; // Import AuthService

class AuthWebViewPage extends StatefulWidget {
  final String authUrl;
  final AuthService authService; // Add AuthService

  AuthWebViewPage({Key? key, required this.authUrl, required this.authService}) : super(key: key);

  @override
  _AuthWebViewPageState createState() => _AuthWebViewPageState();
}

class _AuthWebViewPageState extends State<AuthWebViewPage> {
  final GlobalKey webViewKey = GlobalKey();
  late InAppWebViewController webViewController;
  late CookieManager cookieManager;

  @override
  void initState() {
    super.initState();
    cookieManager = CookieManager.instance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: Uri.parse(widget.authUrl)),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
            javaScriptCanOpenWindowsAutomatically: true,
          ),
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          if (url.toString().startsWith(widget.authService.redirectUri)) {
            _handleRedirect(url);
          }
        },
      ),
    );
  }

  void _handleRedirect(Uri? url) async {
    if (url != null) {
      String? authorizationCode = url.queryParameters['code'];

      if (authorizationCode != null) {
        bool success = await widget.authService.exchangeCodeForToken(authorizationCode);

        if (success) {
          _retrieveCookies();
          print('sucsess');
          // Navigate to the profile page or handle the login success
        } else {
          Navigator.pop(context);
          _showSnackBar('Authentication failed');
        }
      } else {
        Navigator.pop(context);
        _showSnackBar('Authentication error');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _retrieveCookies() async {
    List<Cookie> cookies = await cookieManager.getCookies(url: Uri.parse(widget.authService.redirectUri));
    for (var cookie in cookies) {
      // Handle the retrieved cookies as needed
    }
  }
}