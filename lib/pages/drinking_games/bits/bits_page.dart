import 'package:flutter/material.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/pages/drinking_games/bits/bits_home_page.dart';
import 'package:online_events/services/app_navigator.dart';

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
              padding: EdgeInsets.only(left: padding.left, right: padding.right),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    bitsPages[index].header,
                    style: OnlineTheme.textStyle(size: 20, weight: 7),
                  ),
                  const SizedBox(height: 20),
                  const ClipRRect(child: SizedBox(height: 80)),
                  Text(
                    bitsPages[index].body,
                    style: OnlineTheme.textStyle(),
                  )
                ],
              ),
            ),
          ),

          // Right GestureDetector
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
      PageNavigator.navigateTo(const BitsHomePage());
    }
    setState(() {
      index--;
    });
  }
}

const bitsPages = [
  BitsModel(
    header: 'Pekelek',
    body: 'Pek på den i rommet som har brukt en sjekkereplikk relatert til informatikk.',
  ),
  BitsModel(
    header: 'Chug eller Sannhet',
    body: 'Hva er det rareste stedet du har barbert deg?',
  ),
  BitsModel(
    header: 'Pekelek',
    body: 'Hvem her har hatt seg på A4?',
  ),
];
