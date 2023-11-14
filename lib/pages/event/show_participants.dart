// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:online_events/components/separator.dart';
import 'package:online_events/models/card_participant.dart';

import '/dark_overlay.dart';
import '/theme/theme.dart';

class ShowParticipants extends DarkOverlay {
  @override
  Widget content(BuildContext context, Animation<double> animation) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 25);

    return LayoutBuilder(builder: (context, constraints) {
      final maxSize = min(constraints.maxWidth, constraints.maxHeight);

      // Dynamic creation of participant rows
      List<Widget> participantWidgets = participantModels.map((participant) {
        return Column(
          children: [
            const Separator(margin: 5),
            Row(
              children: [
                Padding(
                  padding: horizontalPadding,
                  child: Text(
                    '${participant.registered}. ',
                    style: OnlineTheme.textStyle(),
                  ),
                ),
                Padding(
                  padding: horizontalPadding,
                  child: Text(
                    participant.name,
                    style: OnlineTheme.textStyle(),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Text(
                    '${participant.year}. klasse',
                    style: OnlineTheme.textStyle(),
                  ),
                ),
              ],
            ),

          ],
        );
      }).toList();

      return Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Påmeldte',
            style: OnlineTheme.textStyle(size: 25, weight: 7),
          ),
          const SizedBox(height: 40),
          ...participantWidgets, 
          const SizedBox(height: 10,),
          const Separator(margin: 5,),
          Text('Venteliste', style: OnlineTheme.textStyle(size: 25, weight: 7),),
          const Separator(margin: 5,),
          Row(
              children: [
                Padding(
                  padding: horizontalPadding,
                  child: Text(
                    '1.',
                    style: OnlineTheme.textStyle(),
                  ),
                ),
                Padding(
                  padding: horizontalPadding,
                  child: Text(
                    'Fredda G',
                    style: OnlineTheme.textStyle(),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 50),
                  child: Text(
                    '3. klasse',
                    style: OnlineTheme.textStyle(),
                  ),
                ),
              ],
            ),

        ],
      );
    });
  }
}


final participantModels = [
  CardParticipantModel(
      name: 'Fredrik Hansteen',
      registered: 1,
      year: 5,
  ),
  CardParticipantModel(
      name: 'Erlend Strøm',
      registered: 2,
      year: 1,
  ),
  CardParticipantModel(
      name: 'Johannes Hage',
      registered: 3,
      year: 1,
  ),
  CardParticipantModel(
      name: 'Mats Nyfløt',
      registered: 4,
      year: 3,
  ),
  CardParticipantModel(
      name: 'Mads Hermansen',
      registered: 5,
      year: 3,
  ),
  CardParticipantModel(
      name: 'Jørgen Galdal',
      registered: 6,
      year: 2,
  ),
  CardParticipantModel(
      name: 'Jo Tjernshaugen',
      registered: 7,
      year: 0,
  ),
  CardParticipantModel(
      name: 'Brage Baugerød',
      registered: 8,
      year: 1,
  ),
  CardParticipantModel(
      name: 'Andrew Tate',
      registered: 9,
      year: 2,
  ),
];