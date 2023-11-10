import 'package:flutter/material.dart';

import '/components/online_scaffold.dart';
import '/theme/theme.dart';

class SettingsPage extends OnlinePage {
  const SettingsPage({super.key});

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
            const SizedBox(height: 17),
            const SizedBox(height: 40),
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
              side: const BorderSide(color: Colors.white), // Outline color for unchecked checkbox
            ),
      ),
      child: Column(
        children: categories.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key, style: OnlineTheme.eventListHeader),
            value: categories[key],
            activeColor: Colors.green, // Color for the filled part of the checkbox when checked
            checkColor: Colors.white, // Color for the check icon when checked
            tileColor: OnlineTheme.gray14,
            onChanged: (bool? value) {
              setState(() {
                categories[key] = value!;
              });
            },
          );
        }).toList(),
      ),
    );
  }
}
