import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '/components/online_scaffold.dart';
// import '/components/separator.dart';
import '/theme/theme.dart';

class NuKlingerPage extends ScrollablePage {
  const NuKlingerPage({super.key});

  String _getText() {
    return '''
### **Vers**
Nu klinger igjennom den gamle stad, på ny en studentersang, 
og alle mann alle i rekke og rad, svinger opp under begerklang! 
Og mens borgerne våker i køya og hører den glade "kang-kang", 
synger alle mann, alle mann, alle mann, alle mann, alle mann, alle mann; \n
---
### **Refreng**
Studenter i den gamle stad, ta vare på byens ry! (klapp x2) 
Husk på at jenter, øl og dram var kjempenes meny. 
Og faller I alle mann alle, skal det gjalle fra alle mot sky. 
La ikke byen få ro, men la den få merke den er en studenterby. 
Og øl og dram, og øl og dram, og øl og dram, og øl og dram. \n
---
### **Vers**
I denne gamle staden satt så mangen en konge stor, og hadde nok av øl fra fat og piker ved sitt bord. 
Og de laga bøljer i gata når hjem ifra gildet de fór. 
Og nu sitter de alle mann alle i valhall og traller til oss i kor;\n
---
### **Refreng**
---
### **Vers**
På Elgeseter var det liv i klosteret dag og natt, der hadde de sin kagge og der hadde de sin skatt.
De herjet i Nonnenes gate og rullet og tullet og datt, og nu skuer de fra himmelen ned og griper sin harpe fatt;\n
---
### **Refreng**
---
### **Vers**
(Adagio) \n
Når vi er vandret hen og staden hviler et øyeblikk, (sakte klapp x2)
så kommer våre sønner og tar opp den gamle skikk;
En lek mellom muntre butuljer, samt aldri så litt erotikk.\n
---
### **Vers**
(Accelerando) \n
Også sitter vi i himmelen og stemmer i vår replikk;\n
---
### **Refreng**
(INGEN ØL OG DRAM ETTER SISTE REFRENG! Men ofte utbrytes det i en "Skål!")\n
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
              'assets/images/nu_klinger.jpg',
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
                  'Nu Klinger',
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
