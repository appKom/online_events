import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import '../../main.dart';
import '/pages/login/login_page.dart';
import '../../services/page_navigator.dart';
import '/theme/theme.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: onPressed,
      childBuilder: (context, hover, pointerDown) {
        return loggedIn ? loggedInContent() : loggedOutContent();
      },
    );
  }

  void onPressed() {
    if (loggedIn) {
      PageNavigator.navigateTo(const ProfilePageDisplay());
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
          child: Image.network(
            'https://cloud.appwrite.io/v1/storage/buckets/658996fac01c08570158/files/${userName}/view?project=65706141ead327e0436a&mode=public',
            fit: BoxFit.cover,
            height: 40,
            width: 40,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              );
            },
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
