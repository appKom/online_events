import 'package:flutter/material.dart';

import '../pages/games/games_page.dart';
import '../pages/login/login_page.dart';
import '../pages/profile/profile_page.dart';
import '/main.dart';
import '/pages/events/my_events_page.dart';
import '/pages/events/not_logged_in_page.dart';
import '/pages/home/home_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import 'animated_button.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  static double height(BuildContext context) {
    final padding = MediaQuery.of(context).padding.bottom;
    return padding + 40 + 24;
  }

  @override
  State<StatefulWidget> createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  int selected = 0;

  // Initialize buttons directly in the declaration
  List<NavbarButton> get buttons => [
        NavbarButton(
          icon: IconType.home,
          activeIcon: IconType.homeFilled,
          onPressed: () => AppNavigator.replaceWithPage(const HomePage()), // Use global loggedIn
        ),
        NavbarButton(
          icon: IconType.calendarClock,
          activeIcon: IconType.calendarClockFilled,
          onPressed: () {
            if (loggedIn) {
              AppNavigator.replaceWithPage(const MyEventsPageDisplay());
            } else {
              AppNavigator.replaceWithPage(const NotLoggedInPage());
            }
          },
        ),
        // NavbarButton(
        //   icon: IconType.pixel,
        //   activeIcon: IconType.pixelFilled,
        //   onPressed: () => AppNavigator.replaceWithPage(const PixelPageDisplay()),
        // ),
        NavbarButton(
          icon: IconType.dices,
          activeIcon: IconType.dicesFilled,
          onPressed: () => AppNavigator.replaceWithPage(const GamesPage()),
        ),
        NavbarButton(
          icon: IconType.settings,
          activeIcon: IconType.settingsFilled,
          onPressed: () {
            if (loggedIn) {
              AppNavigator.replaceWithPage(const ProfilePageDisplay());
            } else {
              AppNavigator.replaceWithPage(const LoginPage());
            }
          },
        ),
      ];

  Widget navButton(int i, double padding) {
    final active = i == selected;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: padding),
        child: AnimatedButton(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            buttons[i].onPressed?.call();

            setState(() {
              selected = i;
            });
          },
          scale: 0.8,
          childBuilder: (context, hover, pointerDown) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ThemedIcon(
                key: UniqueKey(),
                icon: active ? buttons[i].activeIcon : buttons[i].icon,
                size: 24,
                color: active ? OnlineTheme.yellow : OnlineTheme.white,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Container(
      decoration: BoxDecoration(
        color: OnlineTheme.background.withOpacity(0.9),
        border: const Border(top: BorderSide(width: 1, color: OnlineTheme.grayBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          buttons.length,
          (i) => navButton(i, padding.bottom),
        ),
      ),
    );
  }
}

class NavbarButton {
  final IconType icon;
  final IconType activeIcon;
  final void Function()? onPressed;

  const NavbarButton({
    this.onPressed,
    required this.icon,
    IconType? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}
