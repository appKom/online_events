import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '/components/online_scaffold.dart';
import '/core/models/event_model.dart';

class DeleteUser extends StatefulWidget {
  const DeleteUser({super.key});

  @override
  State<DeleteUser> createState() => DeleteUserState();
}

class DeleteUserState extends State<DeleteUser> {
  late InAppWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Padding(
      padding: padding,
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 150,
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse("https://online.ntnu.no/profile/settings/userdata")),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
        ),
      ),
    );
  }
}

class DeleteUserDisplay extends StaticPage {
  const DeleteUserDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return DeleteUser();
  }
}
