import 'package:flutter/material.dart';
import 'package:online_events/pages/login/auth_service.dart';
import 'package:online_events/pages/login/auth_web_view_page.dart';

import 'package:online_events/theme/theme.dart';
import '/components/online_scaffold.dart';
import '/components/animated_button.dart';
import '/components/online_header.dart';

class LoginPage extends StaticPage {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    final hintStyle = OnlineTheme.textStyle(
      color: const Color(0xFF4C566A),
      height: 1,
    );

    final headerStyle = OnlineTheme.textStyle(
      size: 20,
      weight: 7,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Logg Inn', style: headerStyle),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 30,
                    child: Text(
                      'Brukernavn',
                      style: OnlineTheme.textStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: usernameController,
                      obscureText: false,
                      autocorrect: false,
                      style: OnlineTheme.textStyle(size: 14),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: OnlineTheme.gray14,
                        hintText: 'fredrik@stud.ntnu.no',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 30,
                    child: Text(
                      'Passord',
                      style: OnlineTheme.textStyle(),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      autocorrect: false,
                      style: OnlineTheme.textStyle(size: 14),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: OnlineTheme.gray14,
                        hintText: 'fredrik_er_b0b0',
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
              AnimatedButton(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AuthWebViewPage(
                        authUrl: _authService.authUrl,
                        authService: _authService),
                  ));
                },
                childBuilder: (context, hover, pointerDown) {
                  return Container(
                    height: OnlineTheme.buttonHeight,
                    decoration: BoxDecoration(
                      gradient: OnlineTheme.greenGradient,
                      borderRadius: OnlineTheme.buttonRadius,
                    ),
                    child: Center(
                      child: Text(
                        'Logg Inn',
                        style: OnlineTheme.textStyle(),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    // Add any additional validation logic if required
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
