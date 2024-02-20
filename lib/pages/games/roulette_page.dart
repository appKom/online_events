import 'dart:async';
import 'dart:math';

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
  {"title": "LAMBO", "description": "Se der står en fyllehund..."},
  {
    "title": "Waterfall",
    "description":
        "Alle begynner å slurke, når de til venstre av deg slutter så kan du slutte"
  },
  {
    "title": "6 Minutes",
    "description":
        "Finn en spotify playlist, sett på en timer og gjett hvilken sang spiller, hvis du kan sangen gi det til neste mann. Hvis du gjetter artist og navn del ut slurker. Hvis tiden går ut på deg bli ferdig med enheten"
  },
  {"title": "Fullfør", "description": "Drikk opp enhenten din"},
  {
    "title": "Ratling Bog",
    "description": "Sett på ratling bog og håp noen vet reglene"
  },
  {"title": "Slurkevakten", "description": "Gi ut 10 slurker"},
  {"title": "Skål!", "description": "Alle skåler og tar en slurk!"},
  {
    "title": "Single drikker",
    "description": "Alle som ikke har kjæreste slurker 💔"
  },

  {
    "title": "Kategorier",
    "description":
        "Velg en kategori, alle må si noe i den kategorien, den som ikke klarer å komme på noe slurker"
  },
  {
    "title": "Komitee Vors ",
    "description":
        "Hvis du er i en komitee slurker du, hvis du er i Appkom slurker du dobbelt, hvis du er Dotkom slurker du trippelt"
  },
  {
    "title": "Jeg har aldri",
    "description":
        "Ta en runde å si noe de aldri har gjort, de som har gjort det slurker"
  },
  {
    "title": "Slurk din bodycount",
    "description":
        "Slurk din bodycount eller hele enheten din hvis du ikke vil si den 🤫"
  },
  {
    "title": "Opus",
    "description":
        "Sett på Opus på spotify å spill terningleken, trill helt til du får en 6. Da kan du slurke en slurk og gi mobilen videre, hvis beaten dropper mens du har mobilen slurk alt, legg til flere mobiler for mer slurker"
  },
  {
    "title": "Roxanne",
    "description":
        "Sett på hvilken som helst slurke sang du vil, foreslår Roxanne (slurk hver gang de synger Roxanne)"
  },
    {
    "title": "Kahoot!",
    "description":
        "Hvis du har eller har hatt en klasse med Alf Inge Wang må du slurke"
  }, // bruh moment
      {
    "title": "Party Magician",
    "description":
        "Gjør ditt kuleste party triks og velg 2 folk å slurke med deg"
  },
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

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < challenges.length; i++) {
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
            challenges[i]['title']!,
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

    return Container(
      color: OnlineTheme.background,
      child: Center(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Positioned(
              width: size,
              height: size,
              left: -550,
              child: ClipRect(
                child: OverflowBox(
                  maxWidth: size,
                  maxHeight: size,
                  child: Transform.rotate(
                    angle: pi / 2,
                    child: FortuneWheel(
                      onAnimationEnd: () {
                        RouletteOverlay(
                          title: challenges[index]["title"] ?? "",
                          description: challenges[index]["description"] ?? "",
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
