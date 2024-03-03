import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '/components/online_scaffold.dart';
import '/theme/theme.dart';

class LamboPage extends ScrollablePage {
  const LamboPage({super.key});

  String _getText() {
    return '''
### **Tilskuere (T) synger:**
**T:** Se der står en fyllehund, \n
**T:** Mine herrer lambo! \n
**T:** Sett nu flasken for din munn, \n 
**T:** Mine herrer lambo! \n
**T:** Se hvordan den dråpen vanker ned ad halsen på den dranker \n
**T:** Lambo, lambo, mine herrer lambo \n
(Gjentas til enheten er drukket opp) \n
---
### **Dranker (D) synger:**
**D:** Jeg mitt glass utdrukket har, \n
**T:** Mine herrer lambo! \n
**D:** Se der fins ei dråpen kvar, \n
**T:** Mine herrer lambo! \n
**D:** Som bevis der på jeg vender, flasken på dens rette ende \n
(Vender enhet opp ned over hodet som bevis.) \n
---
### **Tilskuere synger:** 
**T:** Lambo, lambo, mine herrer lambo \n
**T:** Han/hun kunne kunsten å være et jævla fyllesvin. \n
**T:** Så går vi til baren hen og sjenker oss en tår (hey!). \n
''';
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
                const SizedBox(height: 24),
                Text(
                  'Lambo',
                  style: OnlineTheme.header(),
                ),
                const SizedBox(height: 24),
                MarkdownBody(
                  data: _getText(),
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: OnlineTheme.textStyle(),
                    h1: const TextStyle(color: OnlineTheme.white),
                    h2: const TextStyle(color: OnlineTheme.white),
                    h3: const TextStyle(color: OnlineTheme.white),
                    h4: const TextStyle(color: OnlineTheme.white),
                    h5: const TextStyle(color: OnlineTheme.white),
                    h6: const TextStyle(color: OnlineTheme.white),
                    horizontalRuleDecoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: OnlineTheme.grayBorder),
                      ),
                    ),
                  ),
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
