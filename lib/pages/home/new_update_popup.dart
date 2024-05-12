import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:online/services/app_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart';
import '/theme/theme.dart';

class NewUpdatePopup extends ScrollablePage {
  const NewUpdatePopup({super.key});

  String _getText() {
    return '''
# Versjon 1.0.5
## **Skyvarslinger**
Det er nå mulig å velge hvilke type arrangementer du ønsker å få varslinger for!
\n
For å gjøre dette er det bare å gå inn på profilsiden din og velge hvilke type arrangementer du ønsker å få varslinger for.
\n 
## **Flere sanger**
Vi har nå lagt til flere sanger i sangboken vår. Sjekk ut "Himmelseng" og "Kamerater hev glasset og Studentvisen".


''';
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    final theme = OnlineTheme.current;
    final fg = OnlineTheme.current.fg;

    return Padding(
      padding: EdgeInsets.only(top: padding.top, bottom: padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(left: padding.left, right: padding.right),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Hva er nytt?',
                  style: OnlineTheme.header(),
                ),
                const SizedBox(height: 24),
                MarkdownBody(
                  data: _getText(),
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: OnlineTheme.textStyle(),
                    h1: TextStyle(color: fg),
                    h2: TextStyle(color: fg),
                    h3: TextStyle(color: fg),
                    h4: TextStyle(color: fg),
                    h5: TextStyle(color: fg),
                    h6: TextStyle(color: fg),
                    horizontalRuleDecoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 1, color: OnlineTheme.current.border)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: AnimatedButton(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('showUpdatePopup', false);
                    AppNavigator.pop();
                  },
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: OnlineTheme.buttonHeight,
                      decoration: BoxDecoration(
                        color: theme.negBg,
                        borderRadius: OnlineTheme.buttonRadius,
                        border: Border.fromBorderSide(BorderSide(color: theme.neg, width: 2)),
                      ),
                      child: Center(
                        child: Text(
                          'Ikke vis igjen',
                          style: OnlineTheme.textStyle(weight: 5, color: theme.negFg),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AnimatedButton(
                  onTap: () {
                    Client.launchInBrowser('https://forms.gle/xUTTN95CuWtSbNCS7');
                  },
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: OnlineTheme.buttonHeight,
                      decoration: BoxDecoration(
                        color: theme.primaryBg,
                        borderRadius: OnlineTheme.buttonRadius,
                        border: Border.fromBorderSide(
                          BorderSide(color: theme.primary, width: 2),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Gi tilbakemelding',
                          style: OnlineTheme.textStyle(weight: 5, color: theme.primaryFg),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
