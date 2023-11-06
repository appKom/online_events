import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/pages/home/home_page.dart';

import 'services/app_navigator.dart';
import 'theme.dart';

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
