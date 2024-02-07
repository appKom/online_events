import 'package:flutter/material.dart';

import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/pages/games/bits/bits_home_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'bits_model.dart';

class BitsGame extends StaticPage {
  const BitsGame({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: OnlineHeader.height(context),
        ),
        const Expanded(child: Bits()),
      ],
    );
  }
}

class Bits extends StatefulWidget {
  const Bits({super.key});

  @override
  State<StatefulWidget> createState() => BitsState();
}

class BitsState extends State<Bits> {
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    const background = Color.fromARGB(255, 225, 10, 189);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            OnlineTheme.background,
            background,
          ],
        ),
      ),
      child: Row(
        children: [
          // Left GestureDetector
          Expanded(
            child: GestureDetector(
              onTap: previous,
              child: Container(color: Colors.transparent),
            ),
          ),

          // Main content
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.only(left: padding.left, right: padding.right,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    bitsPages[index].header,
                    style: OnlineTheme.textStyle(size: 33, weight: 7),
                  ),
                  const SizedBox(height: 20),
                  const ClipRRect(child: SizedBox(height: 80)),
                  Text(
                    bitsPages[index].body,
                    style: OnlineTheme.textStyle(size: 20),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    bitsPages[index].imageSource,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: next,
              child: Container(color: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  int index = 0;

  void next() {
    setState(() {
      index++;
      index = index.clamp(0, bitsPages.length - 1);
    });
  }

  void previous() {
    if (index == 0) {
      AppNavigator.navigateToPage(const BitsHomePage());
    }
    setState(() {
      index--;
    });
  }
}

const bitsPages = [
  BitsModel(
      header: 'Pekelek',
      body: 'Kunne brukt en sjekkereplikk relatert til informatikk.',
      imageSource: 'assets/bits/bitsimage1.png'),
  BitsModel(
      header: 'Fadderuke',
      body: 'Velg to "fadderbarn" som må drikke hver gang du drikker',
      imageSource: 'assets/bits/bitsimage2.png'),
  BitsModel(header: 'Pekelek', body: 'Blir påspandert mest på byen', imageSource: 'assets/bits/bitsimage3.png'),
  BitsModel(
      header: 'Togafest',
      body: 'Bruk et håndkle som toga resten av spillet',
      imageSource: 'assets/bits/bitsimage4.png'),
  BitsModel(header: 'Pekelek', body: 'Smasher mest', imageSource: 'assets/bits/bitsimage5.png'),
  BitsModel(
      header: 'Immball', body: '"Av med buksene" Ta av et valgfrittplagg', imageSource: 'assets/bits/bitsimage6.png'),
  BitsModel(header: 'Pekelek', body: 'Startet å drikke i yngst alder', imageSource: 'assets/bits/bitsimage7.png'),
  BitsModel(
      header: 'Kontoret',
      body: 'Du brukte ikke lokk i mikroen, ta tre straffeslurker',
      imageSource: 'assets/bits/bitsimage8.png'),
  BitsModel(header: 'Pekelek', body: 'Fikk A i exphil', imageSource: 'assets/bits/bitsimage9.png'),
  BitsModel(
      header: 'Appslipp',
      body: 'Alle skåler for å feire utgivelsen av Online-appen',
      imageSource: 'assets/bits/bitsimage10.png'),
  BitsModel(header: 'Pekelek', body: 'Fått flest prikker', imageSource: 'assets/bits/bitsimage11.png'),
  BitsModel(
      header: 'Jobbintervju',
      body: 'Du må forberede deg til jobbintervju, ta en shot!',
      imageSource: 'assets/bits/bitsimage12.png'),
  BitsModel(header: 'SKÅL!', body: '', imageSource: 'assets/bits/bitsskaal.png'),
  BitsModel(header: 'Pekelek', body: 'Passer best inn i Appkom', imageSource: 'assets/bits/bitsimage13.png'),
  BitsModel(
      header: 'Blåtur',
      body: 'Blåturen tar deg til et ukjent sted, drikk av noen andres drikke',
      imageSource: 'assets/bits/bitsimage13.5.png'),
  BitsModel(header: 'Pekelek', body: 'Avslutter festen først', imageSource: 'assets/bits/bitsimage14.png'),
  BitsModel(
      header: 'Surfetur med X-sport',
      body: 'Du blir tatt av en bølge, hvis hvordan du surfer',
      imageSource: 'assets/bits/bitsimage15.png'),
  BitsModel(header: 'Pekelek', body: 'Strøk i ITGK', imageSource: 'assets/bits/bitsimage16.png'),
  BitsModel(
      header: 'Bedpres',
      body: 'Du kan gi ut fem bonger (1 bong = 1 slurk)',
      imageSource: 'assets/bits/bitsimage17.png'),
  BitsModel(
      header: 'Chug eller sannhet',
      body: 'Er det noen i Online du har et øye for',
      imageSource: 'assets/bits/bitsimage18.png'),
  BitsModel(header: 'SKÅL!', body: '', imageSource: 'assets/bits/bitsskaal.png'),
  BitsModel(header: 'Pekelek', body: 'Den som har vært på flest bedpres', imageSource: 'assets/bits/bitsimage19.png'),
  BitsModel(
      header: 'Julebord',
      body: 'Hold en tale i to minutter, hvor du forteller hvorfor du har fortjent å være årets nisse',
      imageSource: 'assets/bits/bitsimage20.png'),
  BitsModel(
      header: 'Årets Nisse',
      body: 'Som årets nisse kan du dele ut 4 slurker',
      imageSource: 'assets/bits/bitsimage21.png'),
  BitsModel(header: 'Pekelek', body: 'Lever fremdeles i russetiden', imageSource: 'assets/bits/bitsimage22.png'),
  BitsModel(header: 'Oktoberfest', body: 'Fullfør drikken din', imageSource: 'assets/bits/bitsimage23.png'),
  BitsModel(header: 'Pekelek', body: 'Tar best lambo', imageSource: 'assets/bits/bitsimage1.png'),
  BitsModel(
      header: 'OW er nede',
      body: 'Drikk fem slurker for å få OW opp igjen',
      imageSource: 'assets/bits/bitsimage24.png'),
  BitsModel(header: 'Pekelek', body: 'Havner oftest på legevakten', imageSource: 'assets/bits/bitsimage25.png'),
  BitsModel(
      header: 'Swap',
      body: 'Bytt et klesplagg med personen til venstre for deg',
      imageSource: 'assets/bits/bitsimage25.5.png'),
  BitsModel(header: 'SKÅL!', body: '', imageSource: 'assets/bits/bitsskaal.png'),
  BitsModel(header: 'Pekelek', body: 'Knuser flest hjerter', imageSource: 'assets/bits/bitsimage26.png'),
  BitsModel(
      header: 'Vinter OL',
      body: 'Du ble forkjølet etter vinter OL, ta en shot for å lindre halsbetennelsen',
      imageSource: 'assets/bits/bitsimage27.png'),
  BitsModel(header: 'Pekelek', body: 'Stjeler fra kiosken', imageSource: 'assets/bits/bitsimage28.png'),
  BitsModel(
      header: 'Gammel og Ung',
      body: 'Eldste og yngste i rommet kan dele ut halvparten av alderen sin i slurker',
      imageSource: 'assets/bits/bitsimage29.png'),
  BitsModel(header: 'Pekelek', body: 'Slipper aldri inn på Samf', imageSource: 'assets/bits/bitsimage30.png'),
  BitsModel(
      header: 'Kok', body: 'Du blir tatt for kok, drikk 5 straffeslurker', imageSource: 'assets/bits/bitsimage31.png'),
  BitsModel(header: 'Pekelek', body: 'Burde bli leder for Online', imageSource: 'assets/bits/bitsimage32.png'),
  BitsModel(
      header: 'Eksamensfest',
      body: 'Alle må drikke tre slurker for å feire at dere er ferdig med eksamen',
      imageSource: 'assets/bits/bitsimage33.png'),
  BitsModel(header: 'Pekelek', body: 'Har mest rizz', imageSource: 'assets/bits/bitsimage34.png'),
  BitsModel(
      header: 'MÅL',
      body: 'Dere er nå ferdig med studiene! Nyt livet som bedrep og ta en lambo hele gjengen!',
      imageSource: 'assets/bits/bitsimage35.png'),
];
