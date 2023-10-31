import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:online_events/pages/loginn/log_inn_page.dart';

import 'package:online_events/pages/profile/profile_page.dart';
import 'package:online_events/theme.dart';

import '../../services/app_navigator.dart';


bool loggedIn = false;

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
    print("Logged in: $loggedIn");

    if (loggedIn) {
      AppNavigator.navigateToRoute(
      CupertinoPageRoute(
        builder: (context) {
          return const ProfilePage();
        },
        maintainState: false,
        // fullscreenDialog:
      ),
      additive: true,
    );
    } else {
      // TODO: Login page
      AppNavigator.navigateToRoute(
      CupertinoPageRoute(
        builder: (context) {
          return const LogInnPage(); // TODO: Change destination
        },
        maintainState: false,
        // fullscreenDialog:
      ),
      additive: true,
    );
    }
  }

  Widget loggedInContent() {
    return SizedBox.square(
      dimension: 48,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/better_profile_picture.jpg',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget loggedOutContent() {
    return SizedBox.square(
      dimension: 48,
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
