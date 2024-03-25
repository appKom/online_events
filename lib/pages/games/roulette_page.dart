import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '../../components/animated_button.dart';
import '../../services/app_navigator.dart';
import '/components/online_scaffold.dart';
import '/dark_overlay.dart';
import '/theme/theme.dart';

class Challenge {
  final String title;
  final String description;

  Challenge({required this.title, required this.description});
}

class RoulettePage extends StaticPage {
  const RoulettePage({super.key});

  @override
  Widget content(BuildContext context) {
    return const Roulette();
  }
}

class Roulette extends StatefulWidget {
  const Roulette({super.key});

  @override
  State<Roulette> createState() => RouletteState();
}

final challenges = [
  Challenge(
    title: 'LAMBO',
    description: 'Se der står en fyllehund...',
  ),
  Challenge(
    title: 'Waterfall',
    description:
        'Alle gjør samme aktivitet. Når personen til venstre for deg stopper kan du stoppe.\n\nPersonen som snurra hjulet begynner!',
  ),
  Challenge(
    title: 'Kategorier',
    description:
        'Velg en kategori. Alle må si noe i kategorien helt til én ikke kommer på noe. Denne personen får 3 slurker.',
  ),
  Challenge(
    title: '6 minutes',
    description:
        'Finn en Spotify-liste, sett på en timer og gjett hvilken sang som spiller. Hvis du gjetter sangen gir du telefonen til nestemann. Hvis du gjetter artist og navn kan du dele ut slurker. Hvis tiden går ut på deg får du 10 slurker.',
  ),
  Challenge(
    title: '''C'mon catch up!''',
    description:
        '10 slurker til personen med færrest slurker. Personen får dele ut 5 nye slurker til en annen de mener trenger dem.',
  ),
  Challenge(
    title: 'Slurke-politiet',
    description: 'Slurke-politiet banker på døra! De gir ut 5 slurker til alle med en drikke i hånda.',
  ),
  Challenge(
    title: '''Rattlin' Bog''',
    description: '''Sett på Rattlin' Bog og håp noen kan reglene!''',
  ),
  Challenge(
    title: 'Slurke-bonanza!',
    description: 'Alle får 3 slurker.',
  ),
  Challenge(
    title: 'Singel-livet',
    description: 'Alle som ikke har kjæreste får 2 slurker, men kan gi bort 1 av dem til en som fortjener det 🥰',
  ),
  Challenge(
    title: 'Jeg har aldri',
    description: 'Ta en runde der alle sier noe de "aldri" har gjort. De som har gjort det får 1 slurk.',
  ),
  Challenge(
    title: 'Opus',
    description:
        'Sett på Opus på Spotify og spill terningleken. Trill helt til du får en 6-er. Da får du 1 slurk og kan gi mobilen videre. Hvis beaten dropper mens du har mobilen taper du. Legg til flere mobiler for mer moro!\n\nPro-tip: Online-appen har innebygd terning',
  ),
  Challenge(
    title: 'Party Magician',
    description:
        'Gjør ditt kuleste partytriks og velg 2 personer som hver får 5 slurker. Har du ingen partytriks får du 10 slurker.',
  ),
  Challenge(
    title: 'Slurke-venner!',
    description: 'Du og personen 5 til høyre for deg er nå slurke-venner! Hver gang en får slurk får begge en slurk.',
  ),
  Challenge(
    title: 'Kjendis',
    description:
        'Pekelek: Hvem i rommet ligner mest på en kjendis? Alle fans (de som pekte på kjendisen) får 5 slurker!',
  ),
];

class RouletteState extends State<Roulette> {
  final StreamController<int> _selected = StreamController<int>();

  static const red = FortuneItemStyle(
    color: OnlineTheme.red,
  );

  static const green = FortuneItemStyle(
    color: OnlineTheme.green,
  );

  static const black = FortuneItemStyle(
    color: OnlineTheme.darkGray,
  );

  final fortuneList = List<FortuneItem>.empty(growable: true);
  late final List<Challenge> challengePool;

  @override
  void initState() {
    super.initState();
    challengePool = List.of(challenges);

    _buildFortuneItems();
  }

  void _buildFortuneItems() {
    fortuneList.clear();
    int nonLamboCount = 0;

    for (int i = 0; i < challengePool.length; i++) {
      late final FortuneItemStyle color;

      if (challengePool[i].title == 'LAMBO') {
        color = green;
      } else {
        if (nonLamboCount % 2 == 0) {
          color = red;
        } else {
          color = black;
        }
        nonLamboCount++;
      }

      fortuneList.add(
        FortuneItem(
          child: Text(
            challengePool[i].title,
            style: OnlineTheme.header(),
          ),
          style: color,
        ),
      );
    }
  }

  void _removeSelectedAndRebuild(int selectedIndex) {
    setState(() {
      challengePool.removeAt(selectedIndex);
      _buildFortuneItems();
    });
  }

  int index = 0;
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    const size = 900.0;

    final query = MediaQuery.of(context);
    final windowWidth = query.size.width;
    final isMobile = OnlineTheme.isMobile(context);

    final padding = query.padding;

    return Container(
      color: OnlineTheme.background,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            width: size,
            height: size,
            left: isMobile ? -550 : windowWidth / 2 - size / 2,
            child: ClipRect(
              child: OverflowBox(
                maxWidth: size,
                maxHeight: size,
                child: Transform.rotate(
                  angle: isMobile ? pi / 2 : 0,
                  child: FortuneWheel(
                    onAnimationEnd: () {
                      final selectedTitle = challengePool[index].title;
                      final selectedDescription = challengePool[index].description;
                      _removeSelectedAndRebuild(index);
                      RouletteOverlay(
                        title: selectedTitle,
                        description: selectedDescription,
                      ).show(context);
                    },
                    alignment: Alignment.center,
                    hapticImpact: HapticImpact.light,
                    animateFirst: false,
                    selected: _selected.stream,
                    items: fortuneList,
                    physics: CircularPanPhysics(
                      duration: const Duration(seconds: 1),
                      curve: Curves.decelerate,
                    ),
                    onFling: () {
                      int nextIndex = random.nextInt(challengePool.length);
                      _selected.add(nextIndex);
                    },
                    onFocusItemChanged: (value) {
                      index = value;
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: padding.top + padding.right,
            right: OnlineTheme.horizontalPadding.right,
            child: AnimatedButton(onTap: () {
              AppNavigator.pop();
            }, childBuilder: (context, hover, pointerDown) {
              return const Icon(
                Icons.close_outlined,
                color: OnlineTheme.white,
                size: 32,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class RouletteOverlay extends DarkOverlay {
  final String title;
  final String description;

  RouletteOverlay({required this.title, required this.description});

  @override
  Widget content(BuildContext context, Animation<double> animation) {
    return IgnorePointer(
      child: Padding(
        padding: OnlineTheme.horizontalPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: OnlineTheme.header(),
            ),
            const SizedBox(height: 24),
            Text(
              description,
              style: OnlineTheme.textStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
