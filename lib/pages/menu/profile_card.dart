import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/components/animated_button.dart';
import 'package:online/components/online_scaffold.dart';
import 'package:online/pages/event/cards/event_card.dart';
import 'package:online/pages/profile/profile_page.dart';
import 'package:online/services/app_navigator.dart';
import 'package:online/services/authenticator.dart';

import '../../core/client/client.dart';
import '../../theme/theme.dart';

class ProfileCard extends StaticPage {
  const ProfileCard({super.key});

  @override
  Widget content(BuildContext context) {
    if (Authenticator.isLoggedIn()) {
      return AnimatedButton(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (Authenticator.isLoggedIn()) {
              AppNavigator.navigateToPage(const ProfilePageDisplay());
            }
          },
          childBuilder: (context, hover, pointerDown) {
            return SizedBox(
              height: 100,
              child: OnlineCard(
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 70,
                      child: ValueListenableBuilder(
                        valueListenable: Client.userCache,
                        builder: (contex, value, child) {
                          return Text(
                            "${value?.firstName} ${value?.lastName}",
                            style: OnlineTheme.textStyle(),
                          );
                        },
                      ),
                    ),
                    Positioned(
                        left: 0,
                        child: ClipOval(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/images/default_profile_picture.png'),
                          ),
                        )),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: SvgPicture.asset(
                        "assets/icons/down_arrow.svg",
                        color: OnlineTheme.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      return AnimatedButton(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            AppNavigator.navigateToPage(const ProfilePageDisplay());
          },
          childBuilder: (context, hover, pointerDown) {
            return SizedBox(
              height: 100,
              child: OnlineCard(
                child: Stack(
                  children: [
                    Positioned(
                        top: 10,
                        left: 70,
                        child: Text(
                          "Du er ikke innlogget",
                          style: OnlineTheme.textStyle(),
                        )),
                    Positioned(
                        left: 0,
                        child: ClipOval(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.asset('assets/images/default_profile_picture.png'),
                          ),
                        ))
                  ],
                ),
              ),
            );
          });
    }
  }
}
