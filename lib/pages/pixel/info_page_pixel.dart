import 'dart:math';

import 'package:flutter/material.dart';

import '/dark_overlay.dart';
import '/theme/theme.dart';
import 'package:online_events/components/separator.dart';

class InfoPagePixel extends DarkOverlay {
  InfoPagePixel();

  @override
  Widget content(BuildContext context, Animation<double> animation) {

    return LayoutBuilder(builder: (context, constraints) {

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Text(
            'Pixel',
            style: OnlineTheme.textStyle(size: 40, weight: 7),
          ),
          const SizedBox(height: 60),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hva er Pixel?',
              style: OnlineTheme.textStyle(size: 25),
            ),
          ),
          const Separator(margin: 2),
          Text(
            '* Pixel er en tjeneste laget av Online for Online. I Pixel kan du dele bilder av ditt daglige Onliner liv med andre Onlinere.',
            style: OnlineTheme.textStyle(),
          ),
          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hvem kan legge ut?',
              style: OnlineTheme.textStyle(size: 25),
            ),
          ),
          const Separator(margin: 2),
          Text('Alle i Online kan legge ut, og kun folk I Online kan se hva som har blitt lagt ut.', style: OnlineTheme.textStyle(),),
          const SizedBox(height: 10,),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hjelp, jeg vil ha et bilde slettet',
              style: OnlineTheme.textStyle(size: 25),
            ),
          ),
          const Separator(margin: 2),
          Text('Dersom du har lagt ut et bilde kan du slette bildet selv. Hvis ikke du har lagt ut bilde, men vil fremdeles ha det slettet, send en mail til fredrik.carsten.hansteen@online.ntnu.no for å få bildet slettet', style: OnlineTheme.textStyle(),)
        ],
      );
    });
  }
}
