import 'package:flutter/material.dart';

import '/pages/home/home_page.dart';
import '../theme/theme.dart';
import 'navbar.dart';

abstract class ScrollablePage extends OnlinePage {
  const ScrollablePage({super.key});

  @override
  Widget build(BuildContext context) {
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
    return content(context);
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

  static ValueNotifier<OnlinePage> page = ValueNotifier(const HomePage());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: OnlineTheme.background,
      child: Stack(
        children: [
          Positioned.fill(
            child: ValueListenableBuilder(
              valueListenable: page,
              builder: (context, page, child) {
                return page;
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: ValueListenableBuilder(
              valueListenable: page,
              builder: (context, page, child) {
                return page.header(context) ?? Container();
              },
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

    // return Material(
    //   color: OnlineTheme.background,
    //   child: Stack(
    //     children: [
    //       Positioned.fill(
    //         child: Padding(
    //           padding: padding,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               const SizedBox(height: 17),
    //               SizedBox(
    //                 height: 48,
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     GestureDetector(
    //                       onTap: () => AppNavigator.navigateTo(
    //                         const HomePage(),
    //                         additive: false,
    //                       ),
    //                       child: SvgPicture.asset(
    //                         'assets/header.svg',
    //                         height: 36,
    //                         fit: BoxFit.fitHeight,
    //                       ),
    //                     ),
    //                     if (header != null) header!,
    //                   ],
    //                 ),
    //               ),
    //               const SizedBox(height: 30),
    //               Expanded(
    //                 child: scrollable ? _scrollableContent() : _staticContent(),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       const Positioned(
    //         left: 0,
    //         right: 0,
    //         bottom: 0,
    //         child: Navbar(),
    //       ),
    //     ],
    //   ),
    // );
  }

  // Widget _staticContent() {
  //   return Column(
  //     children: [
  //       const SizedBox(height: 30),
  //       content,
  //     ],
  //   );
  // }

  // Widget _scrollableContent() {
  //   return ShaderMask(
  //     shaderCallback: (bounds) {
  //       return const LinearGradient(
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //         colors: [
  //           Color(0x00FFFFFF),
  //           Color(0xFFFFFFFF),
  //         ],
  //         stops: [
  //           0.0,
  //           0.05,
  //         ],
  //       ).createShader(bounds);
  //     },
  //     child: SingleChildScrollView(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         children: [
  //           const SizedBox(height: 30),
  //           content,
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
