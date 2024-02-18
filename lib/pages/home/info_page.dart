import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/pages/event/cards/event_card.dart';

import '../../components/animated_button.dart';
import '../../components/online_scaffold.dart';
import '../../core/client/client.dart';
import '../../theme/theme.dart';
import 'developers.dart';

class InfoPage extends ScrollablePage {
  const InfoPage({super.key});

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Row(children: [
            SvgPicture.asset(
              'assets/svg/online_hvit_o.svg',
              fit: BoxFit.cover,
              height: 125,
            ),
            const SizedBox(
              width: 24,
            ),
            Column(
              children: [
                Text("""Online Appen""", style: OnlineTheme.textStyle(size: 32)),
                const SizedBox(
                  height: 12,
                ),
                Text('Versjon 1.0.0', style: OnlineTheme.textStyle(size: 16)),
              ],
            ),
          ]),
          const SizedBox(
            height: 24,
          ),
          OnlineCard(
              child: Text(
                  'Online Appen er utviklet Appkom, og skal gjøre det mulig for Onlinere å motta varslinger før påmeldingsstart for arrangementer. Videre kan brukere melde seg på og av arrangementer, samt se hvem som er påmeldt. I tillegg til dette kan brukere legge til profile bilde og en biografi i brukerprofilen deres, som vil være tilgjengelig for alle Onlinere. \n \n Appen inneholder også innebygde spill og sanger som har som mål å være en integrert del av en Onliners hverdag.',
                  style: OnlineTheme.textStyle(size: 16))),
          const SizedBox(height: 12),
          AnimatedButton(
            onTap: () {
              Client.launchInBrowser('https://forms.gle/xUTTN95CuWtSbNCS7');
            },
            childBuilder: (context, hover, pointerDown) {
              return Container(
                margin: const EdgeInsets.only(top: 10),
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: OnlineTheme.purple1.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5.0),
                  border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.purple1, width: 2)),
                ),
                child: Text(
                  'Gi oss tilbakemelding eller rapporter en bug!',
                  style: OnlineTheme.textStyle(
                    weight: 5,
                    color: OnlineTheme.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'Utviklere',
            style: OnlineTheme.header(),
          ),
          const Center(child: DeveloperCarousel())
        ],
      ),
    );
  }
}
