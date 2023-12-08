import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/main.dart';
import 'package:online_events/pages/home/home_page_loggedin.dart';

import '/components/animated_button.dart';
import '/pages/home/home_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

class OnlineHeader extends StatelessWidget {
  final List<Widget> buttons;

  OnlineHeader({super.key, List<Widget>? buttons})
      : buttons = buttons ?? List.empty(growable: false);

  /// Height of OnlineHeader
  static double height(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return padding.top + 40 + 25 + 25;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    if (loggedIn) {
      return Container(
        padding: EdgeInsets.only(
          left: padding.left + 25,
          right: padding.right + 25,
          top: padding.top + 25,
          bottom: 25,
        ),
        decoration: BoxDecoration(
          color: OnlineTheme.background.withOpacity(0.9),
          border: const Border(
              bottom: BorderSide(width: 1, color: OnlineTheme.gray14)),
        ),
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedButton(
                onTap: () {
                  PageNavigator.navigateTo(const HomePageLoggedIn());
                },
                childBuilder: (context, hover, pointerDown) {
                  return SvgPicture.asset(
                    'assets/svg/online_logo.svg',
                    height: 36,
                  );
                },
              ),
              Row(children: buttons),
            ],
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(
          left: padding.left + 25,
          right: padding.right + 25,
          top: padding.top + 25,
          bottom: 25,
        ),
        decoration: BoxDecoration(
          color: OnlineTheme.background.withOpacity(0.9),
          border: const Border(
              bottom: BorderSide(width: 1, color: OnlineTheme.gray14)),
        ),
        child: SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedButton(
                onTap: () {
                  PageNavigator.navigateTo(const HomePage());
                },
                childBuilder: (context, hover, pointerDown) {
                  return SvgPicture.asset(
                    'assets/svg/online_logo.svg',
                    height: 36,
                  );
                },
              ),
              Row(children: buttons),
            ],
          ),
        ),
      );
    }
  }
}
