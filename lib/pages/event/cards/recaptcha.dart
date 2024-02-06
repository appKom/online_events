import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:online/pages/event/event_page.dart';

import '../../../core/client/client.dart';
import '../../../services/app_navigator.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/core/models/event_model.dart';
import 'package:http/http.dart' as http;

class ReCaptcha extends StatefulWidget {
  const ReCaptcha({super.key, required this.model});

  final EventModel model;

  @override
  State<ReCaptcha> createState() => _RecaptchaState();
}

class _RecaptchaState extends State<ReCaptcha> {
  late InAppWebViewController webViewController;

  Future<void> registerForEvent(String eventId, String reCaptchaToken) async {
  const String verifyCaptchaUrl = 'https://recaptcha-verify-steel.vercel.app/api/verify-recaptcha';

  try {
    final verifyResponse = await http.post(
      Uri.parse(verifyCaptchaUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({"token": reCaptchaToken}),
    );

    final verifyData = json.decode(verifyResponse.body);
    print('verifyData: $verifyData');
    if (verifyData['verified'] == true) {
      final String apiUrl =
          'https://old.online.ntnu.no/api/v1/event/attendance-events/$eventId/register/';
      final Map<String, dynamic> requestBody = {
        "recaptcha": 'true',
        "allow_pictures": true,
        "show_as_attending_event": true,
        "note": "Online app supremacy"
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer ${Client.accessToken}',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        print("You are now registered $reCaptchaToken");
      } else {
        print("Could not register: ${response.body} $reCaptchaToken");
      }
    } else {
      // reCAPTCHA token is invalid, handle accordingly
      print("Invalid reCAPTCHA token: ${verifyData['details']}");
    }
  } catch (e) {
    print("An error has occurred: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 0);
    final topPadding = MediaQuery.of(context).padding;
    String captchaToken = "";

    return SingleChildScrollView(
      child: 
      Padding(padding: topPadding,child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: Uri.parse("https://hansteen.dev/recaptcha")),
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStop: (controller, url) async {
                  controller.addJavaScriptHandler(
                      handlerName: 'handlerCaptcha',
                      callback: (args) {
                        captchaToken = args[0];
                        print("Received token: $captchaToken");
                        recaptchaToken = captchaToken;
                        registerForEvent(widget.model.id.toString(), captchaToken);
                        AppNavigator.navigateToPage(EventPageDisplay(
                          model: widget.model,
                        ));
                      });
                },
              ),
            ),
    
        ],
      ),
      ),
    );
  }
}

class ReCaptchaDisplay extends StaticPage {
  const ReCaptchaDisplay({super.key, required this.model});

  final EventModel model;

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return ReCaptcha(model: model);
  }
}
