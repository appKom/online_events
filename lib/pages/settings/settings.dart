import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/pages/home/profile_button.dart';
import 'package:online_events/pages/home/home_page.dart';
import 'package:online_events/theme/theme.dart';

class SettingsPage extends OnlinePage {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    return Material(
      color: OnlineTheme.background,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 17),
            // ... other widget code ...
            const SizedBox(height: 40),
            const Text(
              'Innstillinger',
              style: OnlineTheme.eventHeader,
            ),

            const SizedBox(height: 10),
            const Text(
              'Huk av de kategoriene du ønsker varslinger for',
              style: OnlineTheme.eventListSubHeader,
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
    return Column(
      children: categories.keys.map((String key) {
        return CheckboxListTile(
          title: Text(key),
          value: categories[key],
          activeColor: Colors.green, // use your theme color here
          checkColor: Colors.white, // use your theme color here
          tileColor: OnlineTheme.gray8,
          onChanged: (bool? value) {
            setState(() {
              categories[key] = value!;
            });
          },
        );
      }).toList(),
    );
  }
}
