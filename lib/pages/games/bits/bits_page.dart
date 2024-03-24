import 'dart:math';

import 'package:flutter/material.dart';
import 'package:online/pages/games/bits/bits_card.dart';

import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'bits_model.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:online/components/animated_button.dart';
import 'package:online/theme/themed_icon.dart';

class BitsGame extends StatefulWidget {
  final List<String> playerNames;

  const BitsGame({super.key, required this.playerNames});

  @override
  State<BitsGame> createState() => _BitsGameState();
}

class _BitsGameState extends State<BitsGame> {
  final SwiperController _controller = SwiperController();
  late List<BitsModel> _shuffledPages;
  late int _currentLength;

  @override
  void initState() {
    super.initState();
    _shuffledPages = _shuffleExceptRyggTilRygg(
        generateBitsModelsWithRandomPlayer().toList(), 'Rygg til rygg');
    _currentLength = _shuffledPages.length;
  }

  List<BitsModel> _shuffleExceptRyggTilRygg(
      List<BitsModel> models, String specifiedHeader) {
    final random = Random();

    List<BitsModel> specifiedModels =
        models.where((m) => m.header == specifiedHeader).toList();

    List<BitsModel> otherModels =
        models.where((m) => m.header != specifiedHeader).toList();
    otherModels.shuffle(random);

    if (specifiedModels.isEmpty || otherModels.isEmpty) {
      return [...specifiedModels, ...otherModels];
    }
    int insertIndex = random.nextInt(otherModels.length + 1);
    otherModels.insertAll(insertIndex, specifiedModels);

    return otherModels;
  }

  Iterable<BitsModel> generateBitsModelsWithRandomPlayer() sync* {
    final random = Random();

    for (final page in bitsPages) {
      var header = page.header;
      var body = page.body;

      if (widget.playerNames.isNotEmpty) {
        String? randomPlayer;
        String? randomPlayer2;

        if (widget.playerNames.length >= 2) {
          int firstIndex = random.nextInt(widget.playerNames.length);
          int secondIndex = firstIndex;

          while (secondIndex == firstIndex) {
            secondIndex = random.nextInt(widget.playerNames.length);
          }

          randomPlayer = widget.playerNames[firstIndex];
          randomPlayer2 = widget.playerNames[secondIndex];
        } else if (widget.playerNames.length == 1) {
          randomPlayer = randomPlayer2 = widget.playerNames.first;
        }
        if (randomPlayer != null && randomPlayer2 != null) {
          header = header
              .replaceAll('Random2', randomPlayer2)
              .replaceAll('Random', randomPlayer);
          body = body
              .replaceAll('Random2', randomPlayer2)
              .replaceAll('Random', randomPlayer);
        }
      }

      yield BitsModel(header: header, body: body);
    }
  }

  Future<void> _onTap(int index) async {
    await _controller.previous();
    setState(() {
      _currentLength = max(0, _currentLength - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    const background = Color.fromARGB(255, 225, 10, 189);

    return Container(
      padding: MediaQuery.of(context).padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [OnlineTheme.purple1, background],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.9],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Bits",
            style: OnlineTheme.textStyle(
              color: OnlineTheme.hundredTitleTextColor,
              size: 30,
              weight: 7,
            ),
          ),
          SizedBox(
            height: 430,
            child: Swiper(
              onIndexChanged: (index) {
                setState(() {
                  _currentLength = max(0, _currentLength - 1);
                });
              },
              onTap: _onTap,
              itemCount: _shuffledPages.length,
              itemWidth: MediaQuery.of(context).size.width,
              itemHeight: MediaQuery.of(context).size.height,
              controller: _controller,
              index: _shuffledPages.length - 1,
              allowImplicitScrolling: true,
              loop: false,
              layout: SwiperLayout.TINDER,
              itemBuilder: (context, index) {
                return Center(
                  child: BitsCard(
                    body: _shuffledPages[index].body,
                    position: _shuffledPages.length - index,
                    header: _shuffledPages[index].header,
                    length: _currentLength,
                  ),
                );
              },
            ),
          ),
          AnimatedButton(
            onTap: AppNavigator.pop,
            scale: 0.9,
            childBuilder: (context, hover, pointerDown) {
              return const ThemedIcon(
                icon: IconType.cross,
                size: 24,
              );
            },
          )
        ],
      ),
    );
  }
}

const bitsPages = [
  BitsModel(
    header: 'Random',
    body:
        'Vi vet alle at du liker å få på. Ta en slurk for hver person i rommet du har ligget med',
  ),
  BitsModel(
    header: 'Random',
    body: 'Velg to "fadderbarn" som tar en slurk hver gang du gjør det"',
  ),
  BitsModel(
    header: 'Fadderuke',
    body:
        'Random lengter tilbake til fadderuken. For å bringe tilbake de gode minnene, må Random si en fun fact om alle i rommet',
  ),
  BitsModel(
    header: 'Lambo!',
    body: 'Random må ta en lambo, alle synger!',
  ),
  BitsModel(
    header: 'Togafest',
    body: 'Random må bruke et håndkle som toga resten av spillet',
  ),
  BitsModel(
      header: 'Rygg til rygg',
      body:
          'Dere kan nå sette dere ned. Det laget med flest poeng kan dele ut 10 slurker til motstander-laget'),
  BitsModel(
    header: 'Rygg til rygg',
    body: 'Hvem stjeler mest fra kiosken?',
  ),
  BitsModel(
    header: 'Rygg til rygg',
    body: 'Hvem tenker høyest om seg selv?',
  ),
  BitsModel(
    header: 'Rygg til rygg',
    body: 'Hvem syntes den selv er morsomst?',
  ),
  BitsModel(
    header: 'Rygg til rygg',
    body: 'Hvem er mest på A4?',
  ),
  BitsModel(
    header: 'Rygg til rygg',
    body: 'Hvem får på mest?',
  ),
  BitsModel(
    header: 'Rygg til rygg',
    body: 'Hvem er litt for glad i flaska?',
  ),
  BitsModel(
    header: 'Rygg til rygg',
    body:
        'Random og Random2 stå rygg til rygg.  Ta en slurk hver gang dere tror påstanden gjelder dere. Dersom kun en drikker, får dere et poeng, dersom begge drikker eller ingen, så får tilskuerne poeng!.',
  ),
  BitsModel(
    header: 'Immball',
    body: 'Random "Av med buksene" Ta av et valgfritt plagg',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Hvem startet å få poeng i yngst alder?',
  ),
  BitsModel(
    header: 'Kontoret',
    body: 'Random du brukte ikke lokk i mikroen, ta 3 slurker',
  ),
  BitsModel(
    header: 'Jobbintervju',
    body: 'Random må forberede seg til jobbintervju, fullfør glasset!',
  ),
  BitsModel(
    header: 'Blåtur',
    body: 'Blåturen tar Random til et ukjent sted, ta noen andres glass',
  ),
  BitsModel(
    header: 'Random',
    body:
        'Vi vet du avslutter festen først, hvem i rommet ønsker du å avslutte festen med?',
  ),
  BitsModel(
    header: 'Surfetur med X-sport',
    body: 'Random blir tatt av en bølge, hvis hvordan du surfer',
  ),
  BitsModel(
    header: 'Bedpres',
    body: 'Random kan gi ut 5 bonger (bong = slurk)',
  ),
  BitsModel(
    header: 'Slurk eller sannhet',
    body: 'Har Random et øye for Random2 ?',
  ),
  BitsModel(
    header: 'Lambo!',
    body: 'Random må ta en lambo, alle synger!',
  ),
  BitsModel(
    header: 'Julebord',
    body:
        'Random må holde en tale i to minutter, Random fortell hvorfor du har fortjent å være årets nisse',
  ),
  BitsModel(
    header: 'Oktoberfest',
    body: 'Random fullfør det du har i hånden',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Hvem tar best lambo? Gjerne demonstrer',
  ),
  BitsModel(
    header: 'OW er nede',
    body: 'Random må ta 5 slurker for å få OW opp igjen',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Hvem havner oftest på legevakten',
  ),
  BitsModel(
    header: 'Swap',
    body: 'Random bytt et klesplagg med Random2',
  ),
  BitsModel(
    header: 'Lambo!',
    body: 'Random må ta en lambo, alle synger!',
  ),
  BitsModel(
    header: 'Random',
    body:
        'Vi vet alle at du knuser flest hjerter, ta en slurk for alle du har ligget med i år',
  ),
  BitsModel(
    header: 'Vinter OL',
    body:
        'Random ble forkjølet etter vinter OL, fullfør glasset for å lindre halsbetennelsen',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Hvem stjeler mest fra kiosken, ',
  ),
  BitsModel(
    header: 'Gammel og Ung',
    body:
        'Eldste og yngste i rommet kan dele ut halvparten av alderen sin i slurker',
  ),
  BitsModel(
    header: 'Kok',
    body:
        'Random blir tatt for kok, del glasset ditt med Random2 for å vise at du er angrer deg',
  ),
  BitsModel(
    header: 'Eksamensfest',
    body: 'Alle tar 3 slurker for å feire at dere er ferdig med eksamen',
  ),
  BitsModel(
    header: 'Random har rizz',
    body: 'Demonstrer rizzen din ovenfor Random2',
  ),
];
