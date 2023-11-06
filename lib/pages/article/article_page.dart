import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/pages/home/profile_button.dart';

import 'package:online_events/pages/home/home_page.dart';
import 'package:online_events/theme.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Material(
        color: OnlineTheme.background,
        child: Padding(
          padding: padding,
          child: SingleChildScrollView(
            // Wrap the column with a SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UpcomingEventsPage()), // Replace with your page class
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/header.svg',
                        height: 36,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    const ProfileButton()
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  // width: 300,
                  // height: 1500,
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Fadderuka 2023',
                        style: OnlineTheme.logInnPageHeader,
                      ),
                      const SizedBox(height: 5),
                      Image.asset(
                        'assets/images/fadderuka2.png',
                        fit: BoxFit.cover,
                        width: 300,
                        height: 111,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Skrevet av: Isabelle Mac Quarrie Nordin, Linn Zhu Yu Grotnes',
                        style: OnlineTheme.promotedArticleAuthor,
                      ),
                      const Divider(
                        color: OnlineTheme.white,
                        thickness: 1,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Hei og masse velkommen til den beste, morsomste og kuleste linjen NTNU har å by på, nemlig informatikk! Vi gleder oss masse til å bli kjent med nettopp deg og derfor har vi planlagt to helt fantastiske fadderuker som du kan være med på!',
                        style: OnlineTheme.promotedArticleAuthor,
                      ),
                      const Divider(
                        color: OnlineTheme.white,
                        thickness: 1,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Fadderukene🫐',
                        style: OnlineTheme.eventBedpressHeader,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Fadderukene kommer kanskje til å være ditt første møte med universitetet og flotte Trondheim. Vi har laget en plan full av morsomme aktiviteter som skal hjelpe deg med å bli kjent med dine nye medstudenter, fremtidige bestevenner, campus, linjen og selvfølgelig Trondheim selv! Det å bli en selvstendig student er ikke bare blåbær, så det er kun teknostart og andre IDI arrangementer som er obligatoriske (dette vil dere få mer informasjon om fra instituttet). Likevel anbefaler vi å være med på så mye sosialt som du orker, men ikke slit deg selv helt ut! Online har alltid morsomme arrangementer man kan være med på etter fadderukene også<3! Noen av arrangementene krever påmelding og det er derfor viktig at du får laget en Online-bruker så fort som mulig slik at dere kan bli med på disse. Frykt ikke, dette kan fadderne dine hjelpe deg med om det oppstår problemer! I tillegg er det noen av påmeldingsarrangementene du må betale litt. Dette kommer ikke til å koste skjorta, men kanskje en kaffe på cafe, aka 50 kr.',
                        style: OnlineTheme.promotedArticleAuthor,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Ukeplan📆',
                        style: OnlineTheme.eventBedpressHeader,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Vi har en klar plan for ukene, men det kan komme endringer underveis. Om dette skulle skje, vil du få beskjed av din fadder, en annen informatikk-student som har gått gjennom nettopp det du kommer til å oppleve. Fadderne er en fin gjeng som skal passe på at alle har det hyggelig og blir kjent. De er også der for deg om du skulle ha noen spørsmål eller trenger noen å snakke med. Denne ukes planen gjelder hovedsakelig for bachelorstudenter, men på noen av arrangementene er det også åpent for masterstudenter. Du får da muligheten til å bli kjent med studenter i alle aldersgrupper og på tvers av trinn.',
                        style: OnlineTheme.promotedArticleAuthor,
                      ),
                      const SizedBox(height: 5),
                      Image.asset(
                        'assets/images/fadderuka3.png',
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Debug⚠️',
                        style: OnlineTheme.eventBedpressHeader,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Det er viktig at alle har gode og trygge opplevelser under og etter fadderukene, men det kan dessverre oppstå uønskede situasjoner. I slike tilfeller har Online et uavhengig varslingssystem kalt Debug, som du kan kontakte hvis du opplever eller observerer noe ubehagelig i studietiden. Kort forklart kan Debug bistå med konfliktløsning og gi råd, og kan kontaktes på Online sin nettside ved å klikke på det oransje utropstegnet. Hvis du vil vite mer i detalj hva Debug gjør og er, så er det bare å lese videre her: https://online.ntnu.no/articles/136',
                        style: OnlineTheme.promotedArticleAuthor,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
