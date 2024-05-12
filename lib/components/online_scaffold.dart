import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/components/animated_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';
import '/pages/home/home_page.dart';
import '/pages/loading/loading_display_page.dart';
import '/services/app_navigator.dart';
import 'navbar.dart';

abstract class ScrollablePage extends OnlinePage {
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

abstract class StaticPage extends OnlinePage {
  const StaticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OnlineTheme.current.bg,
      child: content(context),
    );
  }
}

abstract class OnlinePage extends StatelessWidget {
  const OnlinePage({super.key});

  Widget content(BuildContext context);
}

/// Online logo, valgfri header og scrollbart innhold med fade
class OnlineScaffold extends StatelessWidget {
  const OnlineScaffold({super.key});

  static ValueNotifier<OnlinePage> page = ValueNotifier(const LoadingPageDisplay());

  PreferredSize onlineHeader(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return PreferredSize(
      preferredSize: const Size.fromHeight(75),
      child: AppBar(
        shape: const Border(bottom: BorderSide(width: 1, color: OnlineTheme.grayBorder)),
        backgroundColor: OnlineTheme.current.bg.withOpacity(0.9),
        elevation: 0,
        flexibleSpace: Container(
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
                const Spacer(),
                AnimatedButton(onTap: () {
                  launchUrl(
                    Uri.parse('https://bekk.no'),
                    mode: LaunchMode.externalApplication,
                  );
                }, childBuilder: (context, hover, pointerDown) {
                  return SvgPicture.asset(
                    'assets/svg/bekk.svg',
                    height: 36,
                    colorFilter: ColorFilter.mode(OnlineTheme.current.fg, BlendMode.srcIn),
                  );
                }),
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
      appBar: onlineHeader(context),
      backgroundColor: OnlineTheme.current.bg,
      extendBodyBehindAppBar: true,
      body: Navigator(
        key: AppNavigator.onlineNavigator,
        initialRoute: '/',
        onGenerateInitialRoutes: (NavigatorState navigator, String initialRouteName) {
          return [
            MaterialPageRoute(builder: (context) => const HomePage()),
          ];
        },
      ),
      extendBody: true,
      bottomNavigationBar: const Navbar(),
    );
  }
}
