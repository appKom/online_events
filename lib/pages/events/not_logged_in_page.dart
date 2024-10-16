import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online/components/navbar.dart';
import 'package:online/services/authenticator.dart';

import '/components/online_scaffold.dart';
import '/theme/theme.dart';
import '../../components/animated_button.dart';

// TODO: Redundant? Could provide header to LoginPage and make it reusable
class NotLoggedInPage extends StaticPage {
  const NotLoggedInPage({
    super.key,
  });

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    final theme = OnlineTheme.current;

    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Logg inn for å se dine Arrangementer',
            style: OnlineTheme.header(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AnimatedButton(
            onTap: () => login(context),
            childBuilder: (context, hover, pointerDown) {
              return Container(
                alignment: Alignment.center,
                height: OnlineTheme.buttonHeight,
                decoration: BoxDecoration(
                    color: theme.posBg,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.fromBorderSide(BorderSide(color: theme.pos, width: 2))),
                child: Text(
                  'Logg Inn',
                  style: OnlineTheme.textStyle(weight: 5, color: theme.posFg),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future login(BuildContext context) async {
    final response = await Authenticator.login();

    if (response != null) {
      // AppNavigator.replaceWithPage(const ProfilePageDisplay());

      context.go('/menu/profile');

      NavbarState.setActiveMenu();
    }
  }
}
