import 'package:flutter/material.dart';

import '/components/online_scaffold.dart';
import '/theme/theme.dart';

int year = DateTime.now().year;

class ForeverAlonePage extends ScrollablePage {
  const ForeverAlonePage({super.key});

  String _getText() {
    return '''
  Sangtekster av Kakkmaddafakka 
''';
  }

  List<List<String>> _getTextLines() {
    return [
      ["Alle i appkom", "No one can say I didn't try"],
      ["Alle fra Oslo", "Tried everything to make you feel what I feel"],
      ["Har hatt friår", "Well, I guess I pushed to hard"],
      ["Har tettet doen på A4", "And now you're slipping away"],
      ["Alle som ikke er kompilert", "Feels like my love for you"],
      ["Verten(e)", "Is stopping you from being you"],
      ["Har overlevd algdat", "You shine best without me"],
      ["Skal ha nattmat", "Like all the ones I had before"],
      ["Jentene", "I am forever alone"],
      ["Digger sushi", "Home alone eating sushi for two"],
      ["Har vært/er leder i verv i Online", "Home alone and I'm waiting for someone who never shows up"],
      ["De(n) som kom sist", "Ooh, and I'm lonely, I'm angry I'm tired"],
      ["Har kontet", "You're only giving me drips of your love"],
      ["Big spender på byen", "Appointments, you've been breaking them all"],
      ["Den som skal hoste nach", "It's like a never ending story"],
      ["Har blitt kastet ut av et utested", "I give and you take and I give"],
      ["Crusher på Jim Kurose", "Feels like my love for you"],
      ["Har traktet før", "Is stopping you from being you"],
      ["Gikk rett på studie etter vgs", "You shine best without me"],
      ["Har dusjet med noen andre", "Like all the ones I had before"],
      ["Guttene", "I am forever alone"],
      ["Har kjæreste", "When I held your hand you were sincere"],
      ["Har vært på tinderdate", "But did you ever think about me when I wasn't near you?"],
      ["Har fått sparken", "Why would you ever put me first?"],
      ["Alle som er '04", "You are second to none"],
      ["Alle fra Bergen", "I wanted to leave, I tried to find someone new"],
      ["Bor på Buran", "But I always end up still wanting you"],
      ["Har spydd på A4", "Why do I do this to myself?"],
      ["Tar opp fag", "Feels like my love for you"],
      ["Går med kjole", "Is stopping you from being you"],
      ["Har grått i $year", "You shine best without me"],
      ["Har jukset på eksamen", "Like all the ones I had before"],
      ["Har farget håret sitt før", "I am forever alone"],
      ["Har tatovering (vis)", "When I'm with you, you tell me you love me"],
      ["Den kuleste i rommet", "When you're not I don't even exist"],
      ["Har vært på dobbeldate", "If I ask you if you want to hang with me"],
      ["Alle trøndere", "You got a thousand excuses rehearsed"],
      ["Har bart", "But when you're drunk and got no place to hide"],
      ["Har fylleringt noen", "Who's the one you always call?"],
      ["Har lappen", "Feels like my love for you"],
      ["Alle fra bøgda", "Is stopping you from being you"],
      ["Elsker denne sangen", "You shine best without me"],
      ["Går med briller eller linser", "Like all the ones I had before"],
      ["Har knust mobilskjerm", "I am forever alone"],
      ["Har byttet studie", "My love for you"],
      ["Har vært på TV", "Is stopping you from being you"],
      ["Går med dress", "You shine best without me"],
      ["Sier «er på vei» mens de er hjemme", "Like all the ones I had before"],
      ["Single pringle", "I am forever alone"],
    ];
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    return Padding(
      padding: EdgeInsets.only(top: padding.top, bottom: padding.bottom) + EdgeInsets.symmetric(vertical: 64),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 267,
            child: Image.asset(
              'assets/images/forever_alone.webp',
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
                  'Forever Alone',
                  style: OnlineTheme.header(),
                ),
                const SizedBox(height: 24),
                Text(
                  _getText(),
                  style: OnlineTheme.textStyle().copyWith(fontStyle: FontStyle.italic),
                ),
                Column(
                  children: List.generate(
                    _getTextLines().length,
                    (index){
                      return SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _getTextLines()[index][0],
                                style: index % 2 == 0 ? OnlineTheme.textStyle() : OnlineTheme.textStyle().copyWith(fontWeight: FontWeight.bold),
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Text(
                                _getTextLines()[index][1],
                                style: index % 2 == 0 ? OnlineTheme.textStyle() : OnlineTheme.textStyle().copyWith(fontWeight: FontWeight.bold),
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
