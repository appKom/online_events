import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/components/animated_button.dart';

import '/pages/home/home_page.dart';
import '/services/app_navigator.dart';
import '../theme/theme.dart';
import 'navbar.dart';

abstract class ScrollablePage extends _OnlinePage {
  const ScrollablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OnlineTheme.current.bg,
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            content(context),
          ],
        ),
      ),
    );
  }
}

abstract class StaticPage extends _OnlinePage {
  const StaticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OnlineTheme.current.bg,
      child: content(context),
    );
  }
}

abstract class _OnlinePage extends StatelessWidget {
  const _OnlinePage({super.key});

  Widget content(BuildContext context);
}

/// Online logo, valgfri header og scrollbart innhold med fade
class OnlineScaffold extends StatelessWidget {
  final Widget child;
  final bool showHeaderNavbar; // Flag to control visibility

  const OnlineScaffold({super.key, required this.child, this.showHeaderNavbar = true});

  PreferredSize onlineHeader(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return PreferredSize(
      preferredSize: const Size.fromHeight(75),
      child: AppBar(
        shape: Border(bottom: BorderSide(width: 1, color: OnlineTheme.current.border)),
        backgroundColor: OnlineTheme.current.bg.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 0,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
            left: padding.left + 25,
            right: padding.right + 25,
            top: padding.top + 10,
            bottom: 25,
          ),
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header content (like the logo, buttons)
                AnimatedButton(
                  onTap: () {
                    AppNavigator.replaceWithPage(const HomePage());
                    NavbarState.setActiveHome();
                  },
                  childBuilder: ((context, hover, pointerDown) {
                    return SvgPicture.asset(
                      'assets/svg/online_logo.svg',
                      height: 36,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showHeaderNavbar ? onlineHeader(context) : null, // Conditionally show the app bar
      backgroundColor: OnlineTheme.current.bg,
      extendBodyBehindAppBar: true,
      body: child, // Render the page content
      extendBody: true,
      bottomNavigationBar: showHeaderNavbar ? const Navbar() : null, // Conditionally show the navbar
    );
  }
}
