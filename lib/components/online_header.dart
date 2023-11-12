import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/pages/event/qr_code.dart';
import 'package:online_events/services/app_navigator.dart';
import 'package:online_events/theme/theme.dart';


class OnlineHeader extends StatelessWidget {
  final List<Widget> buttons;

  OnlineHeader({super.key, List<Widget>? buttons}) : buttons = buttons ?? List.empty(growable: false);

  /// Height of OnlineHeader
  static double height(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return padding.top + 40 + 25 + 10;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.only(
        left: padding.left + 25,
        right: padding.right + 25,
        top: padding.top + 10,
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
            AnimatedButton(
              onPressed: () {
                AppNavigator.navigateToRoute(
                  QRCode(
                    name: 'Fredrik Hansteen',
                  ),
                  additive: true,
                );
                // PageNavigator.navigateTo(const HomePage());
              },
              scale: 0.9,
              child: SvgPicture.asset(
                'assets/svg/online_logo.svg',
                height: 36,
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
