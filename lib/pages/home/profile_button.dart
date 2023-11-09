import 'package:flutter/material.dart';

import '../../main.dart';
import '/pages/profile/profile_page.dart';
import '/pages/login/login_page.dart';
import '../../services/page_navigator.dart';
import '/theme/theme.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: loggedIn ? loggedInContent() : loggedOutContent(),
    );
  }

  void onTap() {
    if (loggedIn) {
      PageNavigator.navigateTo(const ProfilePage());
    } else {
      PageNavigator.navigateTo(const LoginPage());
    }
  }

  Widget loggedInContent() {
    return SizedBox.square(
      dimension: 40,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/better_profile_picture.jpg',
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget loggedOutContent() {
    return SizedBox.square(
      dimension: 40,
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: OnlineTheme.blue1,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
