import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      eventCategories.keys.forEach((category) {
        eventCategories[category] = (prefs.getBool(category) ?? eventCategories[category])!;
      });
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
      print("Subscribed to $topicName");
    } else if (subscribed == false) {
      messaging.unsubscribeFromTopic(topicName);
      print("Unsubscribed to $topicName");
    }
  }

  @override
  Widget build(BuildContext context) {
    return OnlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Varslinger', style: OnlineTheme.header()),
          ),
          const SizedBox(height: 10),
          Column(
            children: eventCategories.keys.map((String key) {
              return Container(
                color: OnlineTheme.background,
                child: CheckboxListTile(
                  title: Text(key, style: OnlineTheme.textStyle()),
                  value: eventCategories[key],
                  activeColor: Colors.green,
                  checkColor: Colors.white,
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
