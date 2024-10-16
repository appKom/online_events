import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    return padding + 64;
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

  static final List<NavbarButton> _buttons = [
    NavbarButton(
      icon: IconType.home,
      activeIcon: IconType.homeFilled,
      onPressed: (context) => context.go('/'),
    ),
    NavbarButton(
      icon: IconType.calendarClock,
      activeIcon: IconType.calendarClockFilled,
      onPressed: (context) => context.go('/calendar'),
    ),
    NavbarButton(
      icon: IconType.dices,
      activeIcon: IconType.dicesFilled,
      onPressed: (context) => context.go('/social'),
    ),
    NavbarButton(
      icon: IconType.menu,
      activeIcon: IconType.menuFilled,
      onPressed: (context) => context.go('/menu'),
    ),
  ];

  Widget navButton(int i, double padding, BuildContext context) {
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
                _buttons[i].onPressed?.call(context);

                NavbarState.selected.value = i;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
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

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: OnlineTheme.current.bg.withOpacity(0.8),
            border: Border(top: BorderSide(width: 1, color: OnlineTheme.current.border)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              _buttons.length,
              (i) => navButton(i, padding.bottom, context),
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
  final void Function(BuildContext context)? onPressed;

  const NavbarButton({
    this.onPressed,
    required this.icon,
    IconType? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}
