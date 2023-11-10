import 'package:flutter/material.dart';
import 'package:online_events/pages/drikkeleker/drikkeleker_home.dart';
import 'package:online_events/pages/events/my_events_page.dart';
import 'package:online_events/pages/settings/settings.dart';

import '../services/page_navigator.dart';
import '/pages/home/home_page.dart';
import '/theme/themed_icon.dart';
import 'animated_button.dart';
import '/theme/theme.dart';

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
  static final buttons = [
    NavbarButton(
      icon: IconType.home,
      activeIcon: IconType.homeFilled,
      onPressed: () => PageNavigator.navigateTo(const HomePage()),
    ),
    NavbarButton(
      icon: IconType.calendarClock,
      activeIcon: IconType.calendarClockFilled,
      onPressed: () => PageNavigator.navigateTo(const MyEventsPage()),
    ),
    NavbarButton(
      icon: IconType.beer,
      activeIcon: IconType.beerFilled,
      onPressed: () => PageNavigator.navigateTo(const DrikkelekerHome()),
    ),
    NavbarButton(
      icon: IconType.settings,
      activeIcon: IconType.settingsFilled,
      onPressed: () => PageNavigator.navigateTo(const SettingsPage()),
    ),
  ];

  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

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
          (i) => navButton(i, padding.bottom),
        ),
      ),
    );
  }

  Widget navButton(int i, double padding) {
    final active = i == selected;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: padding),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedButton(
            behavior: HitTestBehavior.opaque,
            onPressed: () {
              buttons[i].onPressed?.call();

              setState(() {
                selected = i;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ThemedIcon(
                key: UniqueKey(),
                icon: active ? buttons[i].activeIcon : buttons[i].icon,
                size: 24,
                color: active ? OnlineTheme.yellow : OnlineTheme.white,
              ),
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
