import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '/components/online_scaffold.dart';
import '/theme/theme.dart';

class KameraterHevGlassetPage extends ScrollablePage {
  const KameraterHevGlassetPage({super.key});

  String _getText() {
    return '''
Info
----

*Alex Brinchmann(1888-1978)* debuterte som forfatter med denne
studentersangen.

Tekst
-----

*Tekst: A. Brinckmann*  
*Mel: Oh My Darling, Clementine*

Kamerater, hev nu glasset  
drikk studenter-tidens skål.  
For Minerva, for Parnasset,  
dine drømmers stolte mål.  
Drikk for gamle glade minner,  
drikk for livets herlighet,  

|: drikk for alle fagre kvinner, 
for din unge kjærlighet. :|

Drikk for hver en dag som blåner,  
drikk for sorgløst godt humør,  
så du selv, når håretgråner,  
er så ung som aldri før. 7"  
Den som først sin lykke vinner,  
det er den som i sitt sinn  

|: bygger mur av lyse minner 
mot hver sorg som trenger inn. :|

Hev da glasset, kamerater.  
Glem idag din sorg og strid,  
drikk en skål for Alma Mater,  
for en glad studentertid.  
Drikk for håpet som vil smykke  
dig en fremtid lys og blid.  

|: Drikk for ungdom, drikk for lykke, 
for en glad studentertid. :|
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
              'assets/images/kameraterhevglasset.png',
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
                  'Kamerater, Hev Nu Glasset!',
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
