import 'package:flutter/material.dart';

import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/theme/theme.dart';

class LamboPage extends ScrollablePage {
  const LamboPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Padding(
      padding: EdgeInsets.only(top: padding.top, bottom: padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 267,
            child: Image.asset(
              'assets/images/lambo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: padding.left, right: padding.right),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Lambo',
                  style: OnlineTheme.textStyle(size: 40, weight: 7),
                ),
                const Separator(margin: 5),
                const SizedBox(height: 5),
                Text(
                  'Tilskuere synger:',
                  style: OnlineTheme.textStyle(size: 16, weight: 7),
                ),
                const Separator(margin: 5),
                Text(
                  'Se der står en fyllehund, mine herrer lambo. Sett nu flasken for din munn, mine herrer lambo. Se hvordan den dråpen vanker ned ad halsen på den dranker Lambo, lambo, mine herrer lambo (Repeteres til vedkommende verset er rettet mot har drukket opp)',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Text(
                  'Dranker synger:',
                  style: OnlineTheme.textStyle(size: 16, weight: 7),
                ),
                const Separator(margin: 5),
                Text(
                  'Jeg mitt glass utdrukket har, mine herrer lambo. Se der fins ei dråpen kvar, mine herrer lambo. Som bevis der på jeg vender, flasken på dens rette ende (Drankeren vender fysisk glass/flaske el. annet med toppen ned over hodet som bevis.)',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Text(
                  'Tilskuere synger:',
                  style: OnlineTheme.textStyle(size: 16, weight: 7),
                ),
                const Separator(margin: 5),
                Text(
                  'Lambo, lambo, mine herrer lambo Hun/han kunne kunsten hun/han var et jævla fyllesvin. Så går vi til nestemann og ser hva hun/han formår. (Finn en ny person og fortsett til man går lei, eller folk er tomme for drikke.)',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
