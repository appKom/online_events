import 'package:flutter/material.dart';
import 'package:online/pages/games/bits/bits_card.dart';

import '/components/online_scaffold.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'bits_model.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:online/components/animated_button.dart';
import 'package:online/theme/themed_icon.dart';

class BitsGame extends StaticPage {
  BitsGame({super.key});

  final controller = SwiperController();

  Future onTap(int idnex) async {
    await controller.previous();
  }

  @override
  Widget content(BuildContext context) {
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
              onTap: onTap,
              itemCount: bitsPages.length,
              itemWidth: MediaQuery.of(context).size.width,
              itemHeight: MediaQuery.of(context).size.height,
              index: bitsPages.length - 1,
              allowImplicitScrolling: true,
              loop: false,
              layout: SwiperLayout.TINDER,
              controller: controller,
              itemBuilder: (context, index) {
                return Center(
                  child: BitsCard(
                    body: bitsPages[index].body,
                    position: bitsPages.length - index,
                    header: bitsPages[index].header,
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
    header: 'MÅL',
    body: 'Dere er nå ferdig med studiene! Nyt livet som bedrep og ta en lambo hele gjengen!',
    imageSource: 'assets/bits/bitsimage35.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Har mest rizz',
    imageSource: 'assets/bits/bitsimage34.png',
  ),
  BitsModel(
    header: 'Eksamensfest',
    body: 'Alle får 3 poeng for å feire at dere er ferdig med eksamen',
    imageSource: 'assets/bits/bitsimage33.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Burde bli leder for Online',
    imageSource: 'assets/bits/bitsimage32.png',
  ),
  BitsModel(
    header: 'Kok',
    body: 'Du blir tatt for kok, du får 5 poeng',
    imageSource: 'assets/bits/bitsimage31.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Slipper aldri inn på Samf',
    imageSource: 'assets/bits/bitsimage30.png',
  ),
  BitsModel(
    header: 'Gammel og Ung',
    body: 'Eldste og yngste i rommet kan dele ut halvparten av alderen sin i poeng',
    imageSource: 'assets/bits/bitsimage29.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Stjeler fra kiosken',
    imageSource: 'assets/bits/bitsimage28.png',
  ),
  BitsModel(
    header: 'Vinter OL',
    body: 'Du ble forkjølet etter vinter OL, du får et kjempe poeng for å lindre halsbetennelsen',
    imageSource: 'assets/bits/bitsimage27.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Knuser flest hjerter',
    imageSource: 'assets/bits/bitsimage18.png',
  ),
  BitsModel(
    header: 'POENG!',
    body: '',
    imageSource: 'assets/bits/bitsskaal.png',
  ),
  BitsModel(
    header: 'Swap',
    body: 'Bytt et klesplagg med personen til venstre for deg',
    imageSource: 'assets/bits/bitsimage25.5.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Havner oftest på legevakten',
    imageSource: 'assets/bits/bitsimage26.png',
  ),
  BitsModel(
    header: 'OW er nede',
    body: 'Du får 5 poeng for å få OW opp igjen',
    imageSource: 'assets/bits/bitsimage25.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Tar best lambo',
    imageSource: 'assets/bits/bitsimage1.png',
  ),
  BitsModel(
    header: 'Oktoberfest',
    body: 'Fullfør det du har i hånden',
    imageSource: 'assets/bits/bitsimage23.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Lever fremdeles i russetiden',
    imageSource: 'assets/bits/bitsimage22.png',
  ),
  BitsModel(
    header: 'Årets Nisse',
    body: 'Som årets nisse kan du dele ut 4 poeng',
    imageSource: 'assets/bits/bitsimage21.png',
  ),
  BitsModel(
    header: 'Julebord',
    body: 'Hold en tale i to minutter, hvor du forteller hvorfor du har fortjent å være årets nisse',
    imageSource: 'assets/bits/bitsimage20.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Den som har vært på flest bedpres',
    imageSource: 'assets/bits/bitsimage19.png',
  ),
  BitsModel(
    header: 'POENG!',
    body: '',
    imageSource: 'assets/bits/bitsskaal.png',
  ),
  BitsModel(
    header: 'Poeng eller sannhet',
    body: 'Er det noen i Online du har et øye for',
    imageSource: 'assets/bits/bitsimage18.png',
  ),
  BitsModel(
    header: 'Bedpres',
    body: 'Du kan gi ut fem poeng',
    imageSource: 'assets/bits/bitsimage17.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Strøk i ITGK',
    imageSource: 'assets/bits/bitsimage16.png',
  ),
  BitsModel(
    header: 'Surfetur med X-sport',
    body: 'Du blir tatt av en bølge, hvis hvordan du surfer',
    imageSource: 'assets/bits/bitsimage15.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Avslutter festen først',
    imageSource: 'assets/bits/bitsimage14.png',
  ),
  BitsModel(
    header: 'Blåtur',
    body: 'Blåturen tar deg til et ukjent sted, ta noen andres poeng',
    imageSource: 'assets/bits/bitsimage13.5.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Passer best inn i Appkom',
    imageSource: 'assets/bits/bitsimage13.png',
  ),
  BitsModel(
    header: 'POENG!',
    body: '',
    imageSource: 'assets/bits/bitsskaal.png',
  ),
  BitsModel(
    header: 'Jobbintervju',
    body: 'Du må forberede deg til jobbintervju, du får et kjempe poeng',
    imageSource: 'assets/bits/bitsimage12.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Fikk A i exphil',
    imageSource: 'assets/bits/bitsimage9.png',
  ),
  BitsModel(
    header: 'Kontoret',
    body: 'Du brukte ikke lokk i mikroen, du får 3 poeng',
    imageSource: 'assets/bits/bitsimage8.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Startet å få poeng i yngst alder',
    imageSource: 'assets/bits/bitsimage7.png',
  ),
  BitsModel(
    header: 'Immball',
    body: '"Av med buksene" Ta av et valgfrittplagg',
    imageSource: 'assets/bits/bitsimage6.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Spiller mest Smash på A4',
    imageSource: 'assets/bits/bitsimage5.png',
  ),
  BitsModel(
    header: 'Togafest',
    body: 'Bruk et håndkle som toga resten av spillet',
    imageSource: 'assets/bits/bitsimage4.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Blir påspandert mest på byen',
    imageSource: 'assets/bits/bitsimage3.png',
  ),
  BitsModel(
    header: 'Fadderuke',
    body: 'Velg to "fadderbarn" som får et "poeng" hver gang du får et "poeng"',
    imageSource: 'assets/bits/bitsimage2.png',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Kunne brukt en sjekkereplikk relatert til informatikk.',
    imageSource: 'assets/bits/bitsimage1.png',
  ),
];
