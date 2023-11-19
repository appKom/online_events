import 'package:flutter/material.dart';
import 'package:online_events/pages/login/auth_service.dart';

import 'package:online_events/theme/theme.dart';
import '/components/online_scaffold.dart';
import '/components/animated_button.dart';
import '/pages/profile/profile_page.dart';
import '/components/online_header.dart';
import '/services/page_navigator.dart';
import '/main.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed from the widget tree
    emailController.dispose();
    passwordController.dispose();
    super.dispose(); // Always call super.dispose() at the end
  }

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

    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Logg Inn',
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
                  controller: emailController,
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
            onTap: () async {
              bool loggedIn = await AuthService()
                  .login(emailController.text, passwordController.text);
              if (loggedIn) {
                PageNavigator.navigateTo(const ProfilePage());
              } else {
                // Show error message
              }
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
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}


