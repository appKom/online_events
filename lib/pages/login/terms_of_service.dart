import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/separator.dart';
import '/pages/home/home_page.dart';
import '/pages/home/profile_button.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import 'auth_web_view_page.dart';

class TermsOfServicePage extends ScrollablePage {
  const TermsOfServicePage({
    super.key,
  });

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
        Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Vilkår for bruk av Online appen',
                  style: OnlineTheme.textStyle(size: 24, weight: 7),
                ),
              ),
              const Separator(margin: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Center(
                  child: Text(
                    'Sist oppdatert: 31.12.2023',
                    style: OnlineTheme.textStyle(),
                  ),
                ),
                const Separator(margin: 10),
                Center(
                  child: Text(
                    '1. Innledning',
                    style: OnlineTheme.textStyle(size: 24, weight: 5),
                  ),
                ),
                const Separator(margin: 5),
                Text(
                  'Velkommen til Online Appen. Disse vilkårene for bruk regulerer din bruk av Online appen, som leveres av Online linjeforeningen for informatikk. Ved å få tilgang til eller bruke vår app, godtar du å være bundet av disse Vilkårene.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Center(
                  child: Text(
                    '2. Bruk av appen',
                    style: OnlineTheme.textStyle(size: 24, weight: 5),
                  ),
                ),
                const Separator(margin: 5),
                Text(
                  'a. Online appen er designet for å gi brukere en oversikt over Online sine arrangementer, varsle brukere når påmeldingen til et arrangement starter, og å gi brukere muligheten til å dele bilder og brukerprofiler med hverandre.',
                  style: OnlineTheme.textStyle(),
                ),
                Text(
                  'b. Appen er kun for personlig, ikke-kommersiell bruk.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Center(
                  child: Text(
                    '3. Brukeratferd',
                    style: OnlineTheme.textStyle(size: 24, weight: 5),
                  ),
                ),
                const Separator(margin: 5),
                Text(
                  'a. Brukere må ikke misbruke appen eller delta i ulovlige eller skadelige aktiviteter.',
                  style: OnlineTheme.textStyle(),
                ),
                Text(
                  'b. Enhver form for trakassering, diskriminering eller støtende oppførsel er forbudt.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Center(
                  child: Text(
                    '4. Eierskap av innhold og immaterielle rettigheter',
                    style: OnlineTheme.textStyle(size: 24, weight: 5),
                  ),
                ),
                const Separator(margin: 5),
                Text(
                  'a. Innholdet som tilbys i appen eies av Online linjeforening for informatikk eller dets lisensgivere og er beskyttet av lover om immaterielle rettigheter.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Center(
                  child: Text(
                    '5. Databeskyttelse og personvern',
                    style: OnlineTheme.textStyle(size: 24, weight: 5),
                  ),
                ),
                const Separator(margin: 5),
                Text(
                  'a. Vi samler inn og bruker personopplysninger i samsvar med vår Personvernpolicy:',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Text(
                  '5a. Informasjon vi samler inn',
                  style: OnlineTheme.textStyle(size: 20, weight: 5),
                ),
                Text(
                  'a. Personopplysninger: Vi kan samle inn personopplysninger som inkluderer, men er ikke begrenset til, ditt navn og studieår.',
                  style: OnlineTheme.textStyle(),
                ),
                Text(
                  'b. Bruksdata: Vi kan samle inn informasjon om hvordan appen brukes, som sidene du besøker og tid brukt på disse sidene.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Text(
                  '5b. Hvordan vi bruker informasjonen',
                  style: OnlineTheme.textStyle(size: 20, weight: 5),
                ),
                Text(
                  'a. For å levere og vedlikeholde vår app.',
                  style: OnlineTheme.textStyle(),
                ),
                Text(
                  'b. For å forbedre brukeropplevelsen.',
                  style: OnlineTheme.textStyle(),
                ),
                Text(
                  'c. For å kommunisere med deg, for eksempel gjennom oppdateringer eller støttehenvendelser.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Text(
                  '5c. Deling av informasjon',
                  style: OnlineTheme.textStyle(size: 20, weight: 5),
                ),
                Text(
                  'a. Vi deler ikke personopplysningene dine med tredjeparter, unntatt som nødvendig for å levere og forbedre tjenestene våre, eller når loven krever det.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Text(
                  '5d. Sikkerhet for dine personopplysninger',
                  style: OnlineTheme.textStyle(size: 20, weight: 5),
                ),
                Text(
                  'a. Vi tar sikkerheten for dine personopplysninger alvorlig og iverksetter tiltak for å beskytte mot uautorisert tilgang, endring, avsløring, eller ødeleggelse.',
                  style: OnlineTheme.textStyle(),
                ),
                Text(
                  '5e. Dine rettigheter',
                  style: OnlineTheme.textStyle(size: 20, weight: 5),
                ),
                Text(
                  'a. Du har rett til å be om tilgang til, retting eller sletting av dine personopplysninger.',
                  style: OnlineTheme.textStyle(),
                ),
                Text(
                  'b. Du har rett til å protestere mot behandling av dine personopplysninger.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Text(
                  '5f. Endringer i denne personvernpolicyen',
                  style: OnlineTheme.textStyle(size: 20, weight: 5),
                ),
                Text(
                  'a. Vi kan oppdatere vår personvernpolicy fra tid til annen. Vi vil varsle deg om eventuelle endringer ved å publisere den nye personvernpolicyen på denne siden.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Center(
                  child: Text(
                    '6. Endringer i appen og vilkårene',
                    style: OnlineTheme.textStyle(size: 24, weight: 5),
                  ),
                ),
                const Separator(margin: 5),
                Text(
                  'a. Vi forbeholder oss retten til å endre eller avvikle appen når som helst uten varsel.',
                  style: OnlineTheme.textStyle(),
                ),
                Text(
                  'b. Disse Vilkårene kan bli oppdatert fra tid til annen, og den nyeste versjonen vil alltid bli lagt ut på vår app.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Center(
                  child: Text(
                    '7. Ansvarsfraskrivelser og begrensning av ansvar',
                    style: OnlineTheme.textStyle(size: 24, weight: 5),
                  ),
                ),
                const Separator(margin: 5),
                Text(
                  'a. Appen leveres "som den er" og "som tilgjengelig" uten noen garantier.',
                  style: OnlineTheme.textStyle(),
                ),
                Text(
                  'b. Online linjeforeningen for informatikk skal ikke være ansvarlig for eventuelle skader eller tap som følge av din bruk av appen.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Center(
                  child: Text(
                    '8. Gjeldende lov',
                    style: OnlineTheme.textStyle(size: 24, weight: 5),
                  ),
                ),
                const Separator(margin: 5),
                Text(
                  'a. Disse Vilkårene er regulert av Personopplysningsloven.',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Center(
                  child: Text(
                    '9. Kontaktinformasjon',
                    style: OnlineTheme.textStyle(size: 24, weight: 5),
                  ),
                ),
                const Separator(margin: 5),
                Text(
                  'For eventuelle spørsmål eller bekymringer om disse Vilkårene, vennligst kontakt oss på appkom@online.ntnu.no',
                  style: OnlineTheme.textStyle(),
                ),
                const Separator(margin: 5),
                Center(
                  child: Text(
                    '10. Anerkjennelse',
                    style: OnlineTheme.textStyle(size: 24, weight: 5),
                  ),
                ),
                const Separator(margin: 5),
                Text(
                  'Ved å bruke vår app, bekrefter du at du har lest og forstått disse Vilkårene og godtar å være bundet av dem.',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(
                  height: 16,
                ),
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: Row(children: [
                  Flexible(
                    child: AnimatedButton(onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginWebView(),
                      ));
                    }, childBuilder: (context, hover, pointerDown) {
                      return Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: OnlineTheme.greenGradient,
                          borderRadius: OnlineTheme.eventButtonRadius,
                        ),
                        child: Center(
                          child: Text(
                            'Godta',
                            style: OnlineTheme.textStyle(),
                          ),
                        ),
                      );
                    }),
                  ),
                  // const Spacer(),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: AnimatedButton(onTap: () {
                      PageNavigator.navigateTo(const HomePage());
                    }, childBuilder: (context, hover, pointerDown) {
                      return Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: OnlineTheme.redGradient,
                          borderRadius: OnlineTheme.eventButtonRadius,
                        ),
                        child: Center(
                          child: Text(
                            'Ikke godta',
                            style: OnlineTheme.textStyle(),
                          ),
                        ),
                      );
                    }),
                  ),
                ]),
              ),
              SizedBox(height: Navbar.height(context) + 40),
            ],
          ),
        ),
      ],
    );
  }
}
