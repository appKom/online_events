import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/animated_button.dart';
import '../../theme/theme.dart';
import '../event/cards/event_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  Map<String, bool> eventCategories = {
    'Bedriftspresentasjoner': false,
    'Kurs': false,
    'Sosialt': false,
    'Annet': false,
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var category in eventCategories.keys) {
        eventCategories[category] = (prefs.getBool(category) ?? eventCategories[category])!;
      }
    });
  }

  Future<void> _savePreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    eventCategories.forEach((category, subscribed) {
      prefs.setBool(category, subscribed);
    });
  }

  void _handleSubscription(String category, bool? subscribed) {
    setState(() {
      eventCategories[category] = subscribed!;
    });
    _savePreferences(); // Save preferences whenever a change is made

    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? topicName;
    if (category == 'Bedriftspresentasjoner') {
      topicName = '2';
    } else if (category == 'Kurs') {
      topicName = '3';
    } else if (category == 'Sosialt') {
      topicName = '1';
    } else {
      topicName = '4';
    }

    if (subscribed == true) {
      messaging.subscribeToTopic(topicName);
    } else if (subscribed == false) {
      messaging.unsubscribeFromTopic(topicName);
    }
  }

  void _showInfoAndroid() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Automatiske varslinger"),
          content: const Text(
              "Huk av for de type arrangementer du ønsker å motta varslinger for. Du vil motta varslinger 15 minutter før påmeldingsstart for arrangementene."),
          actions: <Widget>[
            TextButton(
              child: const Text("Lukk"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialogIOS() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Automatiske varslinger"),
          content: const Text(
              "Huk av for de type arrangementer du ønsker å motta varslinger for. Du vil motta varslinger 15 minutter før påmeldingsstart for arrangementene."),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("Lukk"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OnlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('Varslinger', style: OnlineTheme.header()),
              const SizedBox(
                width: 8,
              ),
              AnimatedButton(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (Platform.isAndroid) {
                      _showInfoAndroid();
                    }
                    if (Platform.isIOS) {
                      _showInfoDialogIOS();
                    }
                  },
                  childBuilder: (context, hover, pointerDown) {
                    return Icon(
                      Icons.info_outline,
                      color: OnlineTheme.current.fg,
                    );
                  }),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            children: eventCategories.keys.map((String key) {
              return Container(
                color: OnlineTheme.current.bg,
                child: CheckboxListTile(
                  title: Text(key, style: OnlineTheme.textStyle()),
                  value: eventCategories[key],
                  activeColor: OnlineTheme.current.pos,
                  checkColor: OnlineTheme.current.fg,
                  contentPadding: const EdgeInsets.all(0),
                  onChanged: (bool? value) {
                    _handleSubscription(key, value);
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
