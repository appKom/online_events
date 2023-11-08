import 'package:flutter/material.dart';

import '/pages/login/login_page.dart';
import '/pages/profile/profile_page.dart';
import '/services/app_navigator.dart';
import '/pages/home/home_page.dart';
import '/theme/themed_icon.dart';
import 'animated_button.dart';
import '/theme/theme.dart';
import '/main.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  static double height(BuildContext context) => 75 + 24;

  @override
  State<StatefulWidget> createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  static final buttons = [
    NavbarButton(
      icon: IconType.home,
      activeIcon: IconType.homeFilled,
      onPressed: () => PageNavigator.navigateTo(const HomePage()),
    ),
    const NavbarButton(
      icon: IconType.calendarClock,
      activeIcon: IconType.calendarClockFilled,
    ),
    const NavbarButton(
      icon: IconType.beer,
      activeIcon: IconType.beerFilled,
    ),
    NavbarButton(
      icon: IconType.settings,
      activeIcon: IconType.settingsFilled,
      onPressed: () {
        if (loggedIn) {
          PageNavigator.navigateTo(const ProfilePage());
        } else {
          PageNavigator.navigateTo(const LoginPage());
        }
      },
    ),
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OnlineTheme.background.withOpacity(0.9),
        border: const Border(top: BorderSide(width: 1, color: OnlineTheme.gray14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          buttons.length,
          navButton,
        ),
      ),
    );
  }

  Widget navButton(int i) {
    final active = i == selected;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50, top: 25),
          child: AnimatedButton(
            behavior: HitTestBehavior.opaque,
            onPressed: () {
              buttons[i].onPressed?.call();

              setState(() {
                selected = i;
              });
            },
            child: ThemedIcon(
              key: UniqueKey(),
              icon: active ? buttons[i].activeIcon : buttons[i].icon,
              size: 24,
              color: active ? OnlineTheme.yellow : OnlineTheme.white,
            ),
          ),
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
