import 'package:flutter/material.dart';

import '../../services/page_navigator.dart';
import '/pages/login/email_sent_page.dart';
import '/components/online_scaffold.dart';
import '/components/animated_button.dart';
import '/components/online_header.dart';
import '/theme/theme.dart';

class ForgottenPasswordPage extends StaticPage {
  const ForgottenPasswordPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    final hintStyle = OnlineTheme.textStyle(
      color: const Color(0xFF4C566A),
      height: 1,
    );

    final headerStyle = OnlineTheme.textStyle(
      size: 20,
      weight: 7,
    );

    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Glemt Passord',
            style: headerStyle,
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 30,
                child: Text(
                  'Email',
                  style: OnlineTheme.textStyle(),
                ),
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  obscureText: true,
                  autocorrect: false,
                  style: OnlineTheme.loginPageEmail,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: OnlineTheme.gray14,
                    hintText: 'fredrik@ntnu.no',
                    hintStyle: hintStyle,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: OnlineTheme.gray15),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: OnlineTheme.gray15),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: AnimatedButton(
                  onPressed: () => PageNavigator.navigateTo(const EmailSentPage()),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: OnlineTheme.green3,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        'Send Mail',
                        style: OnlineTheme.textStyle(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 100),
        ],
      ),
    );
  }
}
