import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

import '/dark_overlay.dart';
import '/theme/theme.dart';

class RoulettePage extends StatefulWidget {
  const RoulettePage({super.key});

  @override
  State<RoulettePage> createState() => _RoulettePageState();
}

final challenges = [
  {
    'title': 'LAMBO',
    'description': 'Se der står en fyllehund...',
  },
  {
    'title': 'Waterfall',
    'description': 'Alle begynner å drikke. Når personen til venstre for deg slutter, kan du slutte.',
  },
  {
    'title': '6 Minutes',
    'description':
        'Finn en Spotify-liste, sett på en timer og gjett hvilken sang som spiller. Hvis du kan sangen gir du telefonen til nestemann. Hvis du gjetter artist og navn kan du dele ut slurker. Hvis tiden går ut på deg drikker du resten av enheten din.'
  },
  {
    'title': 'Fullfør',
    'description': 'Drikk opp enhenten din.',
  },
  {
    'title': 'Ratling Bog',
    'description': 'Sett på Ratling Bog og håp noen vet reglene!',
  },
  {
    'title': 'Slurkevakten',
    'description': 'Gi ut 10 slurker.',
  },
  {
    'title': 'Skål!',
    'description': 'Alle skåler og tar en (stor) slurk!',
  },
  {
    'title': 'Single Drikker',
    'description': 'Alle som ikke har kjæreste tar seg 2 slurker 💔',
  },
  {
    'title': 'Kategorier',
    'description': 'Velg en kategori, alle må si noe i den kategorien, den som ikke klarer å komme på noe slurker'
  },
  {
    'title': 'Komité-Vors ',
    'description':
        'Hvis du er i en komité tar du en slurk. Hvis du er i Appkom tar du 2 slurker. Er du Dotkommer blir det 3 slurker!'
  },
  {
    'title': 'Jeg har aldri',
    'description': 'Ta en runde å si noe de aldri har gjort, de som har gjort det tar en slurk.',
  },
  {
    'title': 'Drikk din bodycount',
    'description': 'Slurk din bodycount eller 10 slurker hvis du ikke vil si den 🤫',
  },
  {
    'title': 'Opus',
    'description':
        'Sett på Opus på Spotify og spill terningleken. Trill helt til du får en 6. Da kan du ta en slurk og gi mobilen videre. Hvis beaten dropper mens du har mobilen taper du. Legg til flere mobiler for mer moro!'
  },
  {
    'title': 'Roxanne',
    'description': 'Sett på hvilken som helst drikke-sang du vil. Foreslår Roxanne (slurk hver gang de synger Roxanne)'
  },
  {
    'title': 'Kahoot!',
    'description': 'Hvis du har eller har hatt en klasse med Alf Inge Wang må du ta en slurk.',
  },
  {
    'title': 'Party Magician',
    'description': 'Gjør ditt kuleste partytriks og velg 2 folk å til å ta en slurk med deg.',
  },
  {
    'title': 'Drikkevenn',
    'description': 'Du og personen 5 til høyre for deg er nå drikkevenner! Hver gang en må drikke må begge drikke.',
  },
  {
    'title': 'Chug-off',
    'description': 'Velg deg en utforder til chug-off! Vinneren kan dele ut 5 slurker. Taperen må skjerpe seg.',
  },
  {
    'title': 'Uteligger',
    'description': 'Pekelek: Hvem i rommet kler seg mest som en uteligger. Uteliggeren drikker 5 slurker.',
  },
  {
    'title': 'Stripper',
    'description': 'Kle av deg et valgfritt klesplagg eller ta 5 slurker med en av det andre kjønn 😘',
  }
];

class _RoulettePageState extends State<RoulettePage> {
  final StreamController<int> _selected = StreamController<int>();

  static const red = FortuneItemStyle(
    color: OnlineTheme.red,
  );

  static const green = FortuneItemStyle(
    color: OnlineTheme.green,
  );

  static const black = FortuneItemStyle(
    color: OnlineTheme.gray13,
  );

  final fortuneList = List<FortuneItem>.empty(growable: true);
  late final List<Map<String, String>> challengePool;

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
            challengePool[i]['title']!,
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
                          title: challengePool[index]['title'] ?? '',
                          description: challengePool[index]['description'] ?? '',
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
    return Padding(
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
    );
  }
}
