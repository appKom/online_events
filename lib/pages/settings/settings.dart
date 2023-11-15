import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';

import '/components/online_scaffold.dart';
import '/theme/theme.dart';

class SettingsPage extends OnlinePage {
  const SettingsPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Material(
      color: OnlineTheme.background,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            
            Expanded(
              child: SingleChildScrollView(
                child: content(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget content(BuildContext context) {
    // We use a StatefulWidget to manage the state of the checkboxes
    return _SettingsContent();
  }
}

class _SettingsContent extends StatefulWidget {
  @override
  __SettingsContentState createState() => __SettingsContentState();
}

class __SettingsContentState extends State<_SettingsContent> {
  bool isPressed = false; // Track if the button is pressed
  Map<String, bool> eventCategories = {
    'Bedriftspresentasjoner': false,
    'Kurs': false,
    'Sosialt': false,
    'Annet': false,
  };
  Map<String, bool> confirmations = {
    'Bekreftelse for påmelding': false,
    'Bekreftelse for avmedling': true,
  };

  @override
  Widget build(BuildContext context) {
    // Override the checkbox theme for this column only
    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              side: const BorderSide(color: Colors.white),
            ),
      ),
      child: Column(
        children: [
          SizedBox(height: Navbar.height(context) + 40),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Innstillinger',
              style: OnlineTheme.eventHeader,
            ),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Varslinger',
              style: OnlineTheme.eventHeader.copyWith(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Huk av de kategoriene du ønsker varslinger for',
            style: OnlineTheme.textStyle(
              color: OnlineTheme.gray9,
            ),
          ),
          const SizedBox(height: 15),
          Column(
            children: eventCategories.keys.map((String key) {
              return Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: OnlineTheme.buttonRadius,
                ),
                color: OnlineTheme.gray14,
                child: CheckboxListTile(
                  title: Text(key, style: OnlineTheme.eventListHeader),
                  value: eventCategories[key],
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  onChanged: (bool? value) {
                    setState(() {
                      eventCategories[key] = value!;
                    });
                  },
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Bekreftelser',
              style: OnlineTheme.eventHeader.copyWith(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: confirmations.keys.map((String key) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: OnlineTheme.gray14,
                child: CheckboxListTile(
                  title: Text(key, style: OnlineTheme.eventListHeader),
                  value: confirmations[key],
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  onChanged: (bool? value) {
                    setState(() {
                      confirmations[key] = value!;
                    });
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: AnimatedButton(
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: OnlineTheme.greenGradient,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Lagre',
                          style: OnlineTheme.textStyle(weight: 5),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          SizedBox(height: Navbar.height(context) + 20),
        ],
      ),
    );
  }
}
