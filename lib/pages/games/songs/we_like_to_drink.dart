import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '/components/online_scaffold.dart';
import '/theme/theme.dart';

class WeLikeToDrinkPage extends ScrollablePage {
  const WeLikeToDrinkPage({super.key});

  String _getText() {
    return '''
We like to drink with *NAVN* \n
'Cause *NAVN* is our mate! \n
And when we drink with *NAVN* \n
*He/she* gets it down in **8!** \n
**7!** \n
**6!** \n
**5!** \n
**4!** \n
**3!** \n
**2!** \n
**1!** \n
---
### **Hvis glasset ikke er tømt:**
Why was he born so beautiful, why was he born at all? \n
He's no fucking use to anyone, he's no fucking use at all! \n
He's a cunt he's a cunt, he's a C U N T cunt!
''';
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    return Padding(
      padding: EdgeInsets.only(top: padding.top, bottom: padding.bottom) + const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 267,
            child: Image.asset(
              'assets/images/we_like_to_drink.png',
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
                  'We like to drink with',
                  style: OnlineTheme.header(),
                ),
                const SizedBox(height: 24),
                MarkdownBody(
                  data: _getText(),
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    p: OnlineTheme.textStyle(),
                    h1: TextStyle(color: OnlineTheme.current.fg),
                    h2: TextStyle(color: OnlineTheme.current.fg),
                    h3: TextStyle(color: OnlineTheme.current.fg),
                    h4: TextStyle(color: OnlineTheme.current.fg),
                    h5: TextStyle(color: OnlineTheme.current.fg),
                    h6: TextStyle(color: OnlineTheme.current.fg),
                    horizontalRuleDecoration: BoxDecoration(
                      border: Border(top: BorderSide(width: 1, color: OnlineTheme.current.border)),
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
