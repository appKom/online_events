import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:online/pages/games/bits/bits_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '/pages/games/bits/bits_home_page.dart';
import '/pages/games/dice.dart';
import '/pages/games/hundred_questions/hundred_questions_page.dart';
import '/pages/games/roulette_page.dart';
import '/pages/games/songs/fader_abraham.dart';
import '/pages/games/songs/himmelseng.dart';
import '/pages/games/songs/kamerater_hev_glasset.dart';
import '/pages/games/songs/lambo.dart';
import '/pages/games/songs/nu_klinger.dart';
import '/pages/games/songs/studenter_visen.dart';
import '/pages/games/songs/we_like_to_drink.dart';
import '/pages/games/spin_line_page.dart';
import 'components/animated_button.dart';
import 'components/navbar.dart';
import 'core/client/calendar_client.dart';
import 'core/client/client.dart';
import 'pages/article/article_page.dart';
import 'pages/event/event_page.dart';
import 'pages/events/events_page.dart';
import 'pages/calendar/calendar_page.dart';
import 'pages/games/games_page.dart';
import 'pages/hobbies/hobby_page.dart';
import 'pages/home/home_page.dart';
import 'pages/home/info_page.dart';
import 'pages/menu/menu_page.dart';
import 'pages/profile/profile_page.dart';
import 'theme/theme.dart';

GlobalKey<NavigatorState> rootNavigator = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _shellNavigator = GlobalKey<NavigatorState>();

class OnlineShell extends StatelessWidget {
  final Widget content;

  const OnlineShell(this.content, {super.key});

  Widget header(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: OnlineTheme.current.bg.withOpacity(0.8),
            border: Border(
              bottom: BorderSide(
                color: OnlineTheme.current.border,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: padding.left + 24,
              right: padding.right + 24,
              bottom: 16,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header content (like the logo, buttons)
                  AnimatedButton(
                    onTap: () {
                      context.go('/');
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
                  // External link or other widgets
                  AnimatedButton(
                    onTap: () {
                      launchUrl(
                        Uri.parse('https://bekk.no'),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    childBuilder: (context, hover, pointerDown) {
                      return SvgPicture.asset(
                        'assets/svg/bekk.svg',
                        height: 36,
                        colorFilter: ColorFilter.mode(OnlineTheme.current.fg, BlendMode.srcIn),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Stack(
      children: [
        content,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: padding.top + 64,
          child: header(context),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: Navbar.height(context),
          child: Navbar(),
        ),
      ],
    );
  }
}

final GoRoute _eventSubRoute = GoRoute(
  path: 'event/:id',
  builder: (context, state) {
    final id = int.parse(state.pathParameters['id']!);

    final event = Client.eventsCache.value[id] ??
        CalendarClient.calendarEventCache.value?.firstWhere(
          (e) => e.id == id,
        );

    if (event != null) {
      return EventPageDisplay(model: event);
    } else {
      throw Exception('Error loading event with id: ${state.pathParameters['id']}');
    }
  },
);

final GoRoute _eventsSubRoute = GoRoute(
  path: 'events',
  builder: (BuildContext context, GoRouterState state) {
    return EventsPage();
  },
  routes: [
    _eventSubRoute,
  ],
);

final GoRouter router = GoRouter(
  navigatorKey: rootNavigator,
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      navigatorKey: _shellNavigator,
      builder: (context, state, child) {
        return OnlineShell(child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            child: const HomePage(),
          ),
          routes: [
            GoRoute(path: 'info', builder: (context, state) => const InfoPage()),
            _eventsSubRoute,
            _eventSubRoute,
            GoRoute(
              path: 'groups/:id',
              builder: (context, state) {
                final group = Client.hobbiesCache.value[state.pathParameters['id']];

                if (group != null) {
                  return HobbyPage(hobby: group);
                } else {
                  throw Exception('Error loading group with id: ${state.pathParameters['id']}');
                }
              },
            ),
            GoRoute(
              path: 'articles/:id',
              builder: (context, state) {
                final article = Client.articlesCache.value[state.pathParameters['id']];

                if (article != null) {
                  return ArticlePage(article: article);
                } else {
                  throw Exception('Error loading article with id: ${state.pathParameters['id']}');
                }
              },
            ),
          ],
        ),
        GoRoute(
          path: '/calendar',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            child: CalendarPageDisplay(),
          ),
          routes: [
            _eventSubRoute,
          ],
        ),
        GoRoute(
          path: '/social',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            child: const GamesPage(),
          ),
          routes: [
            GoRoute(
                path: 'songs',
                builder: (context, state) {
                  return GamesPage();
                },
                routes: [
                  GoRoute(
                    path: 'lambo',
                    builder: (context, state) {
                      return LamboPage();
                    },
                  ),
                  GoRoute(
                    path: 'nu_klinger',
                    builder: (context, state) {
                      return NuKlingerPage();
                    },
                  ),
                  GoRoute(
                    path: 'studenter_visen',
                    builder: (context, state) {
                      return StudenterVisenPage();
                    },
                  ),
                  GoRoute(
                    path: 'kamerater_hev_glasset',
                    builder: (context, state) {
                      return KameraterHevGlassetPage();
                    },
                  ),
                  GoRoute(
                    path: 'himmelseng',
                    builder: (context, state) {
                      return HimmelsengPage();
                    },
                  ),
                  GoRoute(
                    path: 'fader_abraham',
                    builder: (context, state) {
                      return FaderAbrahamPage();
                    },
                  ),
                  GoRoute(
                    path: 'we_like_to_drink',
                    builder: (context, state) {
                      return WeLikeToDrinkPage();
                    },
                  ),
                ]),
            GoRoute(
              path: 'games',
              builder: (context, state) {
                return GamesPage();
              },
              routes: [
                GoRoute(
                  path: 'dice',
                  builder: (context, state) {
                    return DicePage();
                  },
                ),
                GoRoute(
                  path: 'hundred_questions',
                  builder: (context, state) {
                    return HundredQuestionsInfo();
                  },
                ),
                GoRoute(
                  path: 'spinline',
                  builder: (context, state) {
                    return SpinLinePage();
                  },
                ),
                GoRoute(
                  path: 'roulette',
                  builder: (context, state) {
                    return RoulettePage();
                  },
                ),
                GoRoute(
                  path: 'bits',
                  builder: (context, state) {
                    return BitsHomePage();
                  },
                ),
                GoRoute(
                  path: 'bitsgame',
                  builder: (context, state) {
                    final playerNames = state.extra as List<String>? ?? [];
                    return BitsGame(playerNames: playerNames);
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: '/menu',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            child: const MenuPageDisplay(),
          ),
          routes: [
            GoRoute(
              path: 'profile',
              builder: (context, state) {
                return ProfilePageDisplay();
              },
            ),
            GoRoute(path: 'info', builder: (context, state) => const InfoPage()),
          ],
        ),
      ],
    ),
  ],
);
