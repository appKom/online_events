import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';

import '/services/app_navigator.dart';
import '/pages/home/home_page.dart';
import '/theme/themed_icon.dart';
import '../theme/theme.dart';

/// Online logo, valgfri header og scrollbart innhold med fade
class OnlineScaffold extends StatelessWidget {
  final Widget? header;
  final Widget content;

  final bool scrollable;

  const OnlineScaffold({super.key, this.header, required this.content, this.scrollable = true});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Material(
      color: OnlineTheme.background,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 17),
                  SizedBox(
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => AppNavigator.navigateTo(
                            const HomePage(),
                            additive: false,
                          ),
                          child: SvgPicture.asset(
                            'assets/header.svg',
                            height: 36,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        if (header != null) header!,
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: scrollable ? _scrollableContent() : _staticContent(),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Navbar(),
          ),
        ],
      ),
    );
  }

  Widget _staticContent() {
    return Column(
      children: [
        const SizedBox(height: 30),
        content,
      ],
    );
  }

  Widget _scrollableContent() {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x00FFFFFF),
            Color(0xFFFFFFFF),
          ],
          stops: [
            0.0,
            0.05,
          ],
        ).createShader(bounds);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            content,
          ],
        ),
      ),
    );
  }
}

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<StatefulWidget> createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  static const buttons = [
    NavbarButton(
      icon: IconType.home,
      activeIcon: IconType.homeFilled,
      name: 'Hjem',
    ),
    NavbarButton(icon: IconType.calendarClock, name: 'Events'),
    NavbarButton(
      icon: IconType.beer,
      activeIcon: IconType.beerFilled,
      name: 'Leker',
    ),
    NavbarButton(
      icon: IconType.settings,
      activeIcon: IconType.settingsFilled,
      name: 'Innstillinger',
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
          padding: const EdgeInsets.only(bottom: 50, top: 30),
          child: AnimatedButton(
            behavior: HitTestBehavior.opaque,
            onPressed: () {
              setState(() {
                selected = i;
                buttons[i].onPressed?.call();
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
  final String name;
  final void Function()? onPressed;

  const NavbarButton({
    this.onPressed,
    required this.icon,
    required this.name,
    IconType? activeIcon,
  }) : activeIcon = activeIcon ?? icon;
}
