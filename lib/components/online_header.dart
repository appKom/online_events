import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/theme/theme.dart';

import '/pages/home/home_page.dart';
import '../services/page_navigator.dart';

class OnlineHeader extends StatelessWidget {
  final List<Widget> buttons;

  OnlineHeader({super.key, List<Widget>? buttons}) : buttons = buttons ?? List.empty(growable: false);

  /// Height of OnlineHeader
  static double height(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return padding.top + 40 + 25;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.only(
        left: padding.left + 25,
        right: padding.right + 25,
        top: padding.top,
        bottom: 25,
      ),
      decoration: BoxDecoration(
        color: OnlineTheme.background.withOpacity(0.9),
        border: const Border(bottom: BorderSide(width: 1, color: OnlineTheme.gray14)),
      ),
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => PageNavigator.navigateTo(const HomePage()),
              child: SvgPicture.asset(
                'assets/online_logo.svg',
                height: 36,
                // fit: BoxFit.contain,
              ),
            ),
            Row(
              children: buttons,
            ),
          ],
        ),
      ),
    );
  }
}
