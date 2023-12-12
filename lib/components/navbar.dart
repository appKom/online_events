import 'package:flutter/material.dart';
import 'package:online_events/main.dart';
// ignore: unused_import
import 'package:online_events/pages/events/my_events_page_loggedin.dart';
import '/pages/drinking_games/drinking_games_page.dart';
import '/pages/events/my_events_page.dart';
import '/pages/home/home_page.dart';
import '/pages/settings/settings.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import '../services/page_navigator.dart';
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
          onPressed: () => PageNavigator.navigateTo(loggedIn
              ? const HomePage()
              : const HomePage()), // Use global loggedIn
        ),
        NavbarButton(
          icon: IconType.calendarClock,
          activeIcon: IconType.calendarClockFilled,
          onPressed: () => PageNavigator.navigateTo(loggedIn
              ? const MyEventsPageLoggedInDisplay()
              : const MyEventsPage()),
        ),
        NavbarButton(
          icon: IconType.beer,
          activeIcon: IconType.beerFilled,
          onPressed: () => PageNavigator.navigateTo(const DrinkingGamesPage()),
        ),
        NavbarButton(
          icon: IconType.settings,
          activeIcon: IconType.settingsFilled,
          onPressed: () => PageNavigator.navigateTo(const SettingsPage()),
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
        border:
            const Border(top: BorderSide(width: 1, color: OnlineTheme.gray14)),
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
