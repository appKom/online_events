import 'package:flutter/material.dart';

import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/pages/home/profile_button.dart';
import '/theme/theme.dart';

class NuKlingerPage extends ScrollablePage {
  const NuKlingerPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
      buttons: const [
        ProfileButton(),
      ],
    );
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: OnlineHeader.height(context)),
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
              const SizedBox(height: 40),
              Text(
                'Nu Klinger',
                style: OnlineTheme.textStyle(size: 40, weight: 7),
              ),
              const Separator(margin: 5),
              const SizedBox(height: 5),
              Text(
                'Nu klinger igjennom den gamle stad, på ny en studentersang, og alle mann alle i rekke og rad, svinger opp under begerklang! Og mens borgerne våker i køya og hører den glade "kang-kang", synger alle mann, alle mann, alle mann, alle mann, alle mann, alle mann;',
                style: OnlineTheme.textStyle(),
              ),
              const Separator(margin: 8),
              Text(
                'Refreng:',
                style: OnlineTheme.textStyle(size: 16, weight: 7),
              ),
              const Separator(margin: 8),
              Text(
                'Studenter i den gamle stad, ta vare på byens ry! (klapp x2) Husk på at jenter, øl og dram var kjempenes meny. Og faller I alle mann alle, skal det gjalle fra alle mot sky. La ikke byen få ro, men la den få merke den er en studenterby. Og øl og dram, og øl og dram, og øl og dram, og øl og dram.',
                style: OnlineTheme.textStyle(),
              ),
              const SizedBox(height: 8),
              Text(
                'I denne gamle staden satt så mangen en konge stor, og hadde nok av øl fra fat og piker ved sitt bord. Og de laga bøljer i gata når hjem ifra gildet de fór. Og nu sitter de alle mann alle i valhall og traller til oss i kor;',
                style: OnlineTheme.textStyle(),
              ),
              const Separator(margin: 5),
              Text(
                'Refreng:',
                style: OnlineTheme.textStyle(size: 16, weight: 7),
              ),
              const Separator(margin: 5),
              Text(
                'På Elgeseter var det liv i klosteret dag og natt, der hadde de sin kagge og der hadde de sin skatt. De herjet i Nonnenes gate og rullet og tullet og datt, og nu skuer de fra himmelen ned og griper sin harpe fatt;',
                style: OnlineTheme.textStyle(),
              ),
              const Separator(margin: 8),
              Text(
                'Refreng..',
                style: OnlineTheme.textStyle(),
              ),
              const Separator(margin: 8),
              Text(
                '(Adagio)',
                style: OnlineTheme.textStyle(),
              ),
              const SizedBox(height: 8),
              Text(
                'Når vi er vandret hen og staden hviler et øyeblikk, (sakte klapp x2) så kommer våre sønner og tar opp den gamle skikk; En lek mellom muntre butuljer, samt aldri så litt erotikk.',
                style: OnlineTheme.textStyle(),
              ),
              const SizedBox(height: 8),
              Text(
                '(Accelerando)',
                style: OnlineTheme.textStyle(),
              ),
              const SizedBox(height: 8),
              Text(
                'Også sitter vi i himmelen og stemmer i vår replikk;',
                style: OnlineTheme.textStyle(),
              ),
              const Separator(margin: 8),
              Text(
                'Refreng:',
                style: OnlineTheme.textStyle(),
              ),
              const Separator(margin: 8),
              Text(
                '(Tramp/klapp hele siste refreng)',
                style: OnlineTheme.textStyle(),
              ),
              const SizedBox(height: 8),
              Text(
                'Studenter i den gamle stad, ta vare på byens ry! (markant klapp x2) Husk på at jenter, øl og dram var kjempenes meny. Og faller I alle mann alle, skal det gjalle fra alle mot sky. La ikke byen få ro, men la den få merke den er en studenterby.',
                style: OnlineTheme.textStyle(),
              ),
              const SizedBox(height: 8),
              Text(
                '(INGEN ØL OG DRAM ETTER SISTE REFRENG! Men ofte utbrytes det i en "Skål!")',
                style: OnlineTheme.textStyle(),
              ),
              SizedBox(height: Navbar.height(context) + 40),
            ],
          ),
        ),
      ],
    );
  }
}
