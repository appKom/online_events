import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:online_events/core/models/event_model.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';



class ReCaptcha extends StatefulWidget {
  const ReCaptcha({super.key, required this.model});

  final EventModel model;


  @override
  State<ReCaptcha> createState() => _RecaptchaState();
}

class _RecaptchaState extends State<ReCaptcha> {

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 0);
    
    final webView = InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse("https://online.ntnu.no/events/${widget.model.id}")),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          javaScriptEnabled: true,
        ),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: OnlineHeader.height(context)),

          SizedBox(
            height: Navbar.height(context) -60,
          ),

          Padding(
            padding: horizontalPadding,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 150, // Adjust height
              child: webView,
            ),
          ),
        ],
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
