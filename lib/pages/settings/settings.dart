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
            SizedBox(height: Navbar.height(context) + 40),
            const Text(
              'Innstillinger',
              style: OnlineTheme.eventHeader,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Huk av de kategoriene du ønsker varslinger for',
              style: OnlineTheme.textStyle(
                color: OnlineTheme.gray9,
              ),
            ),
            const SizedBox(height: 20),
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
  Map<String, bool> categories = {
    'Bedriftspresentasjoner': false,
    'Kurs': false,
    'Sosialt': false,
    'Annet': false,
  };

  @override
  Widget build(BuildContext context) {
    
    // Override the checkbox theme for this column only
    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              side: const BorderSide(color: Colors.white),
            ),
      ),
      child: Column(
        children: [
          Column(
            children: categories.keys.map((String key) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: OnlineTheme.gray14,
                child: CheckboxListTile(
                  title: Text(key, style: OnlineTheme.eventListHeader),
                  value: categories[key],
                  activeColor: Colors.green,
                  checkColor: Colors.white,
                  onChanged: (bool? value) {
                    setState(() {
                      categories[key] = value!;
                    });
                  },
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20), // Space between checkboxes and buttone between checkboxes and button
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: AnimatedButton(
                  onPressed: () {
                    //Save logic
                  },
                  scale: 0.9,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: OnlineTheme.green3,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Lagre',
                        style: OnlineTheme.textStyle(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
