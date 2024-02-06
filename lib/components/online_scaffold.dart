import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      color: OnlineTheme.background,
      child: SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            content(context),
          ],
        ),
      ),
      // child: ShaderMask(
      //   shaderCallback: (bounds) {
      //     return const LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [
      //         Color(0x00FFFFFF),
      //         Color(0xFFFFFFFF),
      //       ],
      //       stops: [
      //         0.0,
      //         0.05,
      //       ],
      //     ).createShader(bounds);
      //   },
      //   child: SingleChildScrollView(
      //     padding: EdgeInsets.zero,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         content(context),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}

abstract class StaticPage extends OnlinePage {
  const StaticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OnlineTheme.background,
      child: content(context),
    );
  }
}

abstract class OnlinePage extends StatelessWidget {
  const OnlinePage({super.key});

  Widget? header(BuildContext context) => null;
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
        backgroundColor: OnlineTheme.background.withOpacity(0.9),
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
                SvgPicture.asset(
                  'assets/svg/online_logo.svg',
                  height: 36,
                ),
                const Spacer(),
                SvgPicture.asset(
                  'assets/svg/bekk.svg',
                  height: 36,
                  colorFilter: const ColorFilter.mode(OnlineTheme.white, BlendMode.srcIn),
                ),
                // TODO: Flexible way to set these per page
                // Row(children: buttons),
              ],
            ),
          ),
        ),
        // leading: SizedBox(
        //   height: 40,
        //   child: SvgPicture.asset(
        //     'assets/svg/online_logo.svg',
        //     height: 36,
        //   ),
        // ),
        // bottom: Container(child: ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: onlineHeader(context),
      backgroundColor: OnlineTheme.background,
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
