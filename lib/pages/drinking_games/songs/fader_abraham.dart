import 'package:flutter/material.dart';

import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/theme/theme.dart';

class FaderAbrahamPage extends ScrollablePage {
  const FaderAbrahamPage({super.key});

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
              'assets/images/faderabraham.png',
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
                  'Fader Abraham',
                  style: OnlineTheme.textStyle(size: 40, weight: 7),
                ),
                const Separator(margin: 5),
                const SizedBox(height: 5),
                Text(
                  'Fader abraham har fire sønner, ja fire sønner, har fader abraham! Også drakk de litt (drikk.) Også drakk de litt (drikk.) Og de moret seg og sang; “Høyre arm”',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fader abraham har fire sønner, ja fire sønner, har fader abraham! Også drakk de litt (drikk.) Også drakk de litt (drikk.) Og de moret seg og sang; “Høyre arm, venstre arm”',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 8),
                Text(
                  'I denne gamle staden satt så mangen en konge stor, og hadde nok av øl fra fat og piker ved sitt bord. Og de laga bøljer i gata når hjem ifra gildet de fór. Og nu sitter de alle mann alle i valhall og traller til oss i kor;',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fader abraham har fire sønner, ja fire sønner, har fader abraham! Også drakk de litt (drikk.) Også drakk de litt (drikk.) Og de moret seg og sang; “Høyre arm, venstre arm, høyre fot”',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fader abraham har fire sønner, ja fire sønner, har fader abraham! Også drakk de litt (drikk.) Også drakk de litt (drikk.) Og de moret seg og sang; “Høyre arm, venstre arm, høyre fot”',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fader abraham har fire sønner, ja fire sønner, har fader abraham! Også drakk de litt (drikk.) Også drakk de litt (drikk.) Og de moret seg og sang; “Høyre arm, venstre arm, høyre fot, venstre fot”',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fader abraham har fire sønner, ja fire sønner, har fader abraham! Også drakk de litt (drikk.) Også drakk de litt (drikk.) Og de moret seg og sang; “Høyre arm, venstre arm, høyre fot, venstre fot, rumpa ut”',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fader abraham har fire sønner, ja fire sønner, har fader abraham! Også drakk de litt (drikk.) Også drakk de litt (drikk.) Og de moret seg og sang; “Høyre arm, venstre arm, høyre fot, venstre fot, rumpa ut, kroppen frem”',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Fader abraham har fire sønner, ja fire sønner, har fader abraham! Også drakk de litt (drikk.) Også drakk de litt (drikk.) Og de moret seg og sang; “Høyre arm, venstre arm, høyre fot, venstre fot, rumpa ut, kroppen frem, tunga ut”',
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
