import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '/components/online_scaffold.dart';
import '/theme/theme.dart';

class HimmelsengPage extends ScrollablePage {
  const HimmelsengPage({super.key});

  String _getText() {
    return '''
## Info

Dette er en sang med kun ett originalt vers og ett refreng. Alle vers etter det første er vers man legger til underveis.

Det oppfordres her til at folk dokumenterer hendelser i form av vers til denne sangen, dermed kan onlinere synge om sin historie i lang tid fremover!

### Første vers

Jeg ønsker meg en himmelseng  
en himmelseng med speil i,  
så jeg kan ligge og speile meg  
og se hvor jeg er deilig.  

### Refreng

Hey lå li lå li lå  
li lå li lå li låa,  
hey lå li lå li lå  
li lå li lå li låa!  
Ompa ompa ompa sprut,  
ompa ompa sprut sprut!  

## Linjeforeningenes Himmelsengvers, nyeste først

Jeg har alltid vært en datanerd,               
jeg meldte meg i Online.                                 
Nå ser jeg aldri damer mer                           
og kommer aldri on-time 

--

Jeg meldte meg i Abakus,  
Jeg ville programmere.  
Men ingen sa jeg aldri  
skulle se en jente mer'e

-- 

jeg pratet litt med rektor'n vår  
jeg skulle inn på teppet  
men det vakke kjeft å få  
så UA måtte deppe

--

Jeg møtte ei jente på bedpress 
Med teknologiporten
Hun spurte meg om speedintervju
Det endte med aborten 

## Onlines Himmelsengvers, nyeste først


_Øyvind Schjerven_

Jeg var en gang på styrevors,

Jeg ville ha en stor pikk,

Snart skal jeg på do en tur,

Da tar jeg med meg Henrik 

—

_Sigurd Oxaas Wie_

Da jeg var ny i Trondheim by,          
Så meldte jeg meg inn i Kjellern.       
Fire år det har jo gått          
og jeg må bytt ut levern

--

_Magnus Kongshem_

Jeg skulle vinne Tour de Øl  
jeg måtte ut å klatre,  
men klatringa ble litt for hard  
jeg måtte finne bøtte

--

_Marius Krakeli's vers_  

Vi var en tur på eventyr  
på eventyr med styret  
Krakels dansa gangnam-style,  
slo dama si i tryne  

--

_Kristian Laskemoen's vers_

vi skulle drekk i sogndal  
vi drakk nok ikke opp alt  
men kristian ville ha no mer  
han ville prøve lokalt  

--

_Trond Martin Nyhus' vers_  

vi sku' ut etter vinstraff  
og bussen måtte vente  
for trond han fikk litt mye vin  
og spydde som ei jente  

--

_Håvard Svae Slettvold's vers_  

vi sku på onlines julebord  
vi spiste ikke trøffel  
vi hadde eget styrebord  
men håvard han var tøffel  

--

## Avslutningsverset

jeg trenger ingen himmelseng  
en himmelseng med speil i  
jeg trenger ikke speile meg  
jeg vet hvor jeg er deilig
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
              'assets/images/himmelseng.png',
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
                  'Himmelseng',
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
