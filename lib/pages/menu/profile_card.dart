import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart';
import '/pages/event/cards/event_card.dart';
import '/pages/menu/menu_page.dart';
import '/pages/profile/profile_page.dart';
import '/services/app_navigator.dart';
import '/services/authenticator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';

class ProfileCard extends StaticPage {
  const ProfileCard({super.key});

  Future<void> _logout() async {
    await Authenticator.logout();
    AppNavigator.replaceWithPage(const MenuPageDisplay());
  }

  Widget logoutButton(ThemeConfig theme) {
    return SizedBox(
      height: 40,
      child: AnimatedButton(
        onTap: _logout,
        childBuilder: (context, hover, pointerDown) {
          return Container(
            height: OnlineTheme.buttonHeight,
            decoration: BoxDecoration(
              color: theme.primaryBg,
              borderRadius: OnlineTheme.buttonRadius,
              border: Border.fromBorderSide(
                BorderSide(color: theme.primary, width: 2),
              ),
            ),
            child: Center(
              child: Text(
                'Logg Ut',
                style: OnlineTheme.textStyle(weight: 5, color: theme.primaryFg),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget loggedInCard(ThemeConfig theme) {
    return AnimatedButton(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (Authenticator.isLoggedIn()) {
          AppNavigator.navigateToPage(const ProfilePageDisplay());
        }
      },
      childBuilder: (context, hover, pointerDown) {
        return OnlineCard(
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/images/default_profile_picture.png'),
                  ),
                ),
                const SizedBox(width: 24),
                ValueListenableBuilder(
                  valueListenable: Client.userCache,
                  builder: (contex, value, child) {
                    return Text(
                      "${value?.firstName} ${value?.lastName}",
                      style: OnlineTheme.textStyle(),
                    );
                  },
                ),
                Expanded(child: Container()),
                RotatedBox(quarterTurns: -1, child: ThemedIcon(icon: IconType.downArrow, size: 24))
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _login() async {
    final response = await Authenticator.login();

    if (response != null) {
      AppNavigator.replaceWithPage(const MenuPageDisplay());
      NavbarState.setActiveMenu();
    }
  }

  AnimatedButton loginButton(ThemeConfig theme) {
    return AnimatedButton(
      onTap: () async {
        _login();
      },
      childBuilder: (context, hover, pointerDown) {
        return Container(
          height: OnlineTheme.buttonHeight,
          decoration: BoxDecoration(
            color: theme.posBg,
            borderRadius: OnlineTheme.buttonRadius,
            border: Border.fromBorderSide(
              BorderSide(color: theme.pos, width: 2),
            ),
          ),
          child: Center(
            child: Text(
              'Logg Inn',
              style: OnlineTheme.textStyle(weight: 5, color: theme.posFg),
            ),
          ),
        );
      },
    );
  }

  Widget notLoggedInCard(ThemeConfig theme) {
    return SizedBox(
      height: 164,
      child: OnlineCard(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/images/default_profile_picture.png'),
                  ),
                ),
                const SizedBox(width: 24),
                Text(
                  "Du er ikke logget inn",
                  style: OnlineTheme.textStyle(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 40,
              child: loginButton(theme),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget content(BuildContext context) {
    final theme = OnlineTheme.current;
    bool loggedIn = Authenticator.isLoggedIn();

    return loggedIn ? loggedInCard(theme) : notLoggedInCard(theme);
  }
}
