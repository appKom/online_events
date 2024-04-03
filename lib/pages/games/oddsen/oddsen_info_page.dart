import 'dart:core';

import 'package:flutter/material.dart';

import '../../../components/separator.dart';
import '/dark_overlay.dart';

import '/theme/theme.dart';

class OddsenOverlay extends DarkOverlay {
  OddsenOverlay();

  @override
  Widget content(BuildContext context, Animation<double> animation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              'Oddsen',
              style: OnlineTheme.textStyle(size: 40, weight: 7),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hva er Oddsen?',
                style: OnlineTheme.textStyle(size: 25),
              ),
            ),
            const Separator(margin: 2),
            Text(
              'Oddsen er et spill som går ut på at du oppgir et tall og motstanderen din oppgir et tall. Dersom motstanderen din oppgir riktig tall vinner den, oppgir mostanderen feil tall vinner du.',
              style: OnlineTheme.textStyle(),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hvorfor Odddsen?',
                style: OnlineTheme.textStyle(size: 25),
              ),
            ),
            const Separator(margin: 2),
            Text(
              'Oddsen er en perfekt måte å avgjøre hvorvidt noen må gjøre et veddemål!',
              style: OnlineTheme.textStyle(),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hjelp, jeg har tapt oddsen!',
                style: OnlineTheme.textStyle(size: 25),
              ),
            ),
            const Separator(margin: 2),
            Text(
              'Dersom du har tapt oddsen er du pliktig til å oppfylle det du har lovet!',
              style: OnlineTheme.textStyle(),
            )
          ],
        ),
      ),
    );
  }
}
