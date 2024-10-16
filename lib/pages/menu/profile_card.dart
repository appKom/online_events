import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart';
import '/pages/event/cards/event_card.dart';
import '/services/authenticator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';

class ProfileCard extends StaticPage {
  const ProfileCard({super.key});

  Future<void> _logout(BuildContext context) async {
    await Authenticator.logout();

    if (context.mounted) {
      context.go('/menu');
    }
  }

  Widget logoutButton(ThemeConfig theme, BuildContext context) {
    return SizedBox(
      height: 40,
      child: AnimatedButton(
        onTap: () {
          _logout(context);
        },
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

  Widget loggedInCard(ThemeConfig theme, BuildContext context) {
    return AnimatedButton(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.go('/menu/profile');
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
                  builder: (contex, user, child) {
                    return Text(
                      "${user?.firstName} ${user?.lastName}",
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

  Future<void> _login(BuildContext context) async {
    final response = await Authenticator.login();

    if (response != null) {
      if (context.mounted) {
        context.go('/menu');
      }
    }
  }

  AnimatedButton loginButton(ThemeConfig theme, BuildContext context) {
    return AnimatedButton(
      onTap: () async {
        await _login(context);
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

  Widget notLoggedInCard(ThemeConfig theme, BuildContext context) {
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
              child: loginButton(theme, context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget content(BuildContext context) {
    final theme = OnlineTheme.current;

    return ValueListenableBuilder(
      valueListenable: Authenticator.loggedIn,
      builder: (context, loggedIn, child) {
        return loggedIn ? loggedInCard(theme, context) : notLoggedInCard(theme, context);
      },
    );
  }
}
