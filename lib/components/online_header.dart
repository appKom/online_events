import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/theme/theme.dart';

class OnlineHeader extends StatelessWidget {
  final List<Widget> buttons;

  OnlineHeader({super.key, List<Widget>? buttons})
      : buttons = buttons ?? List.empty(growable: false);

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
        border: const Border(
            bottom: BorderSide(width: 1, color: OnlineTheme.grayBorder)),
      ),
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/online_logo.svg',
              height: 36,
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/svg/bekk.svg',
              height: 36,
              colorFilter:
                  const ColorFilter.mode(OnlineTheme.white, BlendMode.srcIn),
            ),
            Row(children: buttons),
          ],
        ),
      ),
    );
  }
}
