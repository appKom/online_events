import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart';
import '/pages/event/cards/event_card.dart';
import '/theme/theme.dart';

class InfoPage extends ScrollablePage {
  const InfoPage({super.key});

  static const _version = '1.2.0';

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    final theme = OnlineTheme.current;

    return Padding(
      padding: padding + EdgeInsets.symmetric(vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Row(children: [
            SvgPicture.asset(
              'assets/svg/online_hvit_o.svg',
              fit: BoxFit.cover,
              height: 100,
            ),
            const SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Online-Appen", style: OnlineTheme.textStyle(size: 32)),
                const SizedBox(height: 10),
                Text('Versjon $_version', style: OnlineTheme.textStyle(size: 16)),
              ],
            ),
          ]),
          const SizedBox(
            height: 24,
          ),
          OnlineCard(
            child: Column(
              children: [
                Text(
                  'Online-Appen er utviklet av Appkom. Appen skal gjøre det mulig for Onlinere å motta varslinger før påmeldingsstart for arrangementer.',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 24),
                Text(
                  'Videre kan brukere melde seg på og av arrangementer, samt se hvem som er påmeldt. I tillegg til dette kan brukere legge til profilbilde og en biografi i brukerprofilen deres, som vil være tilgjengelig for alle Onlinere.',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 24),
                Text(
                  'Appen inneholder også innebygde spill og sanger som har som mål å være en integrert del av en Onliners hverdag.',
                  style: OnlineTheme.textStyle(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AnimatedButton(
            onTap: () {
              Client.launchInBrowser('https://forms.gle/xUTTN95CuWtSbNCS7');
            },
            childBuilder: (context, hover, pointerDown) {
              return Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.primaryBg,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.fromBorderSide(BorderSide(color: theme.primary, width: 2)),
                ),
                child: Text(
                  'Gi Tilbakemelding!',
                  style: OnlineTheme.textStyle(
                    weight: 5,
                    color: theme.primaryFg,
                  ),
                ),
              );
            },
          ),
          // const SizedBox(height: 24 + 24),
          // Text(
          //   'Utviklere',
          //   style: OnlineTheme.header(),
          // ),
          // const SizedBox(height: 24),
          // const Center(child: DeveloperCarousel()),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
