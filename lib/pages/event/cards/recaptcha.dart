import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaPage extends StatelessWidget {
  final Function(String) onRecaptchaResolved;

  RecaptchaPage({Key? key, required this.onRecaptchaResolved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recaptcha')),
      body: WebView(
        initialUrl: 'https://yourserver.com/recaptcha', // Replace with your URL
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {},
        javascriptChannels: <JavascriptChannel>{
          _recaptchaChannel(context),
        },
      ),
    );
  }

  JavascriptChannel _recaptchaChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'RecaptchaFlutterChannel',
      onMessageReceived: (JavascriptMessage message) {
        String token = message.message;
        if (token.isNotEmpty) {
          onRecaptchaResolved(token);
          Navigator.pop(context); // Close the webview after getting the token
        }
      }
    );
  }
}