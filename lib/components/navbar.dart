import 'package:flutter/material.dart';
import 'package:online/pages/feed/feed_page.dart';
import 'package:online/pages/menu/menu_page.dart';

import '../pages/games/games_page.dart';
import '/pages/events/not_logged_in_page.dart';
import '/pages/home/home_page.dart';
import '/services/app_navigator.dart';
import '/services/authenticator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';

enum NavbarPage {
  home,
  events,
  games,
  menu,
}

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  static double height(BuildContext context) {
    final padding = MediaQuery.of(context).padding.bottom;
    return padding + 40 + 24;
  }

  static void _navigateHome() {
    AppNavigator.replaceWithPage(const HomePage());
    NavbarState.selected.value = 0;
  }

  static void _navigateEvents() {
    if (Authenticator.isLoggedIn()) {
      AppNavigator.replaceWithPage(const FeedPageDisplay());
    } else {
      AppNavigator.replaceWithPage(const NotLoggedInPage());
    }
    NavbarState.selected.value = 1;
  }

  static void _navigateGames() {
    AppNavigator.replaceWithPage(const GamesPage());
    NavbarState.selected.value = 2;
  }

  static void _navigateMenu() {
    AppNavigator.replaceWithPage(const MenuPageDisplay());
    NavbarState.selected.value = 3;
  }

  static void navigateTo(NavbarPage page) {
    switch (page) {
      case NavbarPage.home:
        return _navigateHome();
      case NavbarPage.events:
        return _navigateEvents();
      case NavbarPage.games:
        return _navigateGames();
      case NavbarPage.menu:
        return _navigateMenu();
    }
  }

  @override
  State<StatefulWidget> createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  static ValueNotifier<int> selected = ValueNotifier(0);

  static void setActiveHome() {
    selected.value = 0;
  }

  static void setActiveMenu() {
    selected.value = 3;
  }

  static const List<NavbarButton> _buttons = [
    NavbarButton(
      icon: IconType.home,
      activeIcon: IconType.homeFilled,
      onPressed: Navbar._navigateHome,
    ),
    NavbarButton(
      icon: IconType.calendarClock,
      activeIcon: IconType.calendarClockFilled,
      onPressed: Navbar._navigateEvents,
    ),
    NavbarButton(
      icon: IconType.dices,
      activeIcon: IconType.dicesFilled,
      onPressed: Navbar._navigateGames,
    ),
    NavbarButton(
      icon: IconType.menu,
      activeIcon: IconType.menuFilled,
      onPressed: Navbar._navigateMenu,
    ),
  ];

  Widget navButton(int i, double padding) {
    return ValueListenableBuilder(
      valueListenable: selected,
      builder: (context, selected, child) {
        final active = i == selected;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: padding),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _buttons[i].onPressed?.call();

                NavbarState.selected.value = i;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ThemedIcon(
                  key: UniqueKey(),
                  icon: active ? _buttons[i].activeIcon : _buttons[i].icon,
                  size: 24,
                  color: active ? OnlineTheme.current.primary : OnlineTheme.current.fg,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Container(
      decoration: BoxDecoration(
        color: OnlineTheme.current.bg.withOpacity(0.9),
        border: const Border(top: BorderSide(width: 1, color: OnlineTheme.grayBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          _buttons.length,
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
