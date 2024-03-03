import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

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
        'Velg en kategori. Alle må si noe i kategorien helt til én ikke kommer på noe. Denne personen får 3 poeng.',
  ),
  Challenge(
    title: '6 minutes',
    description:
        'Finn en Spotify-liste, sett på en timer og gjett hvilken sang som spiller. Hvis du gjetter sangen gir du telefonen til nestemann. Hvis du gjetter artist og navn kan du dele ut poeng. Hvis tiden går ut på deg får du 10 poeng.',
  ),
  Challenge(
    title: '''C'mon catch up!''',
    description:
        '10 poeng til personen med færrest poeng. Personen får dele ut 5 nye poeng til en annen de mener trenger dem.',
  ),
  Challenge(
    title: 'Poeng-politiet',
    description: 'Poeng-politiet banker på døra! De gir ut 5 poeng til alle med en drikke i hånda.',
  ),
  Challenge(
    title: '''Rattlin' Bog''',
    description: '''Sett på Rattlin' Bog og håp noen kan reglene!''',
  ),
  Challenge(
    title: 'Poeng-bonanza!',
    description: 'Alle får 3 poeng.',
  ),
  Challenge(
    title: 'Singel-livet',
    description: 'Alle som ikke har kjæreste får 2 poeng, men kan gi bort 1 av dem til en som fortjener det 🥰',
  ),
  Challenge(
    title: 'Komité-Vors',
    description: 'Hvis du er i en komité får du 1 poeng. Hvis du er i Appkom får du 2. Er du Dotkommer får du 3!',
  ),
  Challenge(
    title: 'Jeg har aldri',
    description: 'Ta en runde der alle sier noe de "aldri" har gjort. De som har gjort det får 1 poeng.',
  ),
  Challenge(
    title: 'Opus',
    description:
        'Sett på Opus på Spotify og spill terningleken. Trill helt til du får en 6-er. Da får du 1 poeng og kan gi mobilen videre. Hvis beaten dropper mens du har mobilen taper du. Legg til flere mobiler for mer moro!\n\nPro-tip: Online-appen har innebygd terning',
  ),
  Challenge(
    title: 'Kahoot!',
    description: 'Hvis du har eller har hatt en klasse med Alf Inge Wang får du 1 poeng.',
  ),
  Challenge(
    title: 'Party Magician',
    description:
        'Gjør ditt kuleste partytriks og velg 2 personer som hver får 5 poeng. Har du ingen partytriks får du 10 poeng.',
  ),
  Challenge(
    title: 'Poeng-venner!',
    description: 'Du og personen 5 til høyre for deg er nå poeng-venner! Hver gang en får poeng får begge poeng.',
  ),
  // Challenge(
  //   title: 'Uteligger',
  //   description: 'Pekelek: Hvem i rommet kler seg mest som en uteligger. Uteliggeren får 5 poeng.',
  // ),
  Challenge(
    title: 'Kjendis',
    description: 'Pekelek: Hvem i rommet ligner mest på en kjendis? Alle fans (de som pekte på kjendisen) får 5 poeng!',
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

    challengePool = challenges.sample(20);

    for (int i = 0; i < challengePool.length; i++) {
      late final FortuneItemStyle color;

      if (i == 0) {
        color = green;
      } else if (i % 2 == 0) {
        color = red;
      } else {
        color = black;
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

  int index = 0;
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    const size = 900.0;

    final windowWidth = MediaQuery.of(context).size.width;
    final isMobile = OnlineTheme.isMobile(context);

    return Container(
      color: OnlineTheme.background,
      child: Center(
        child: Stack(
          alignment: isMobile ? Alignment.centerLeft : Alignment.centerLeft,
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
                        RouletteOverlay(
                          title: challengePool[index].title,
                          description: challengePool[index].description,
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
                        _selected.add(random.nextInt(challenges.length));
                      },
                      onFocusItemChanged: (value) {
                        index = value;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
