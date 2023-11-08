import 'package:flutter/material.dart';

import '/pages/login/forgotten_password_page.dart';
import 'package:online_events/theme/theme.dart';
import '/pages/profile/profile_page.dart';
import '/pages/home/profile_button.dart';
import '/services/app_navigator.dart';
import '/menu.dart';

class LoginPage extends Menu {
  @override
  Widget content(BuildContext context, Animation<double> animation) {
    final hintStyle = OnlineTheme.textStyle(
      color: const Color(0xFF4C566A),
      height: 1,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Logg Inn',
            style: OnlineTheme.loginPageHeader,
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 30,
                child: Text(
                  'Email',
                  style: OnlineTheme.loginPageEmail,
                ),
              ),
              SizedBox(
                height: 40,
                child: TextField(
                  obscureText: false,
                  autocorrect: false,
                  style: OnlineTheme.loginPageEmail,
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
              const SizedBox(
                height: 30,
                child: Text(
                  'Passord',
                  style: OnlineTheme.loginPageEmail,
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
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    loggedIn = true;
                    AppNavigator.pop();
                    AppNavigator.iosNavigateTo(const ProfilePage());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: OnlineTheme.white,
                    backgroundColor: OnlineTheme.green3, // Set the text color to white
                    minimumSize: const Size(double.infinity, 50), // Set the button to take the full width
                  ),
                  child: const Text(
                    'Logg Inn',
                    style: TextStyle(
                      fontFamily: OnlineTheme.font,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    AppNavigator.pop();
                    AppNavigator.iosNavigateTo(const ForgottenPasswordPage());
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: OnlineTheme.white,
                    backgroundColor: OnlineTheme.red1, // Set the text color to white
                    minimumSize: const Size(double.infinity, 50), // Set the button to take the full width
                  ),
                  child: const Text(
                    'Glemt Passord',
                    style: TextStyle(
                      fontFamily: OnlineTheme.font,
                      fontSize: 16,
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
