import 'package:flutter/material.dart';
import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/separator.dart';
import '/pages/profile/profile_page.dart';
import '/services/app_navigator.dart';

import '../../main.dart';
import '../login/login_page.dart';
import '/components/online_scaffold.dart';
import '/theme/theme.dart';

class SettingsOverviewPage extends StaticPage {
  const SettingsOverviewPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text('Innstillinger', style: OnlineTheme.header()),
          pageLink('Profil', _onProfileTapped),
          pageLink('Innstillinger', _onSettingsTapped),
        ],
      ),
    );
  }

  void _onProfileTapped() {
    if (loggedIn) {
      AppNavigator.navigateToPage(const ProfilePageDisplay());
    } else {
      AppNavigator.navigateToPage(const LoginPage());
    }
  }

  void _onSettingsTapped() {
    AppNavigator.navigateToPage(const SettingsPage());
  }

  Widget pageLink(String title, void Function() onTap) {
    return SizedBox(
      height: 60,
      child: AnimatedButton(
        onTap: onTap,
        scale: 0.95,
        behavior: HitTestBehavior.opaque,
        childBuilder: (context, hover, pointerDown) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: OnlineTheme.subHeader(),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.navigate_next,
                        color: OnlineTheme.gray9,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const Separator(),
            ],
          );
        },
      ),
    );
  }
}

class SettingsPage extends StaticPage {
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

Map<String, bool> confirmations = {
  'Bekreftelse for påmelding': false,
  'Bekreftelse for avmelding': true,
};

class __SettingsContentState extends State<_SettingsContent> {
  bool isPressed = false; // Track if the button is pressed
  Map<String, bool> eventCategories = {
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
                borderRadius: BorderRadius.circular(5),
              ),
              side: const BorderSide(color: Colors.white),
            ),
      ),
      child: Column(
        children: [
          SizedBox(height: Navbar.height(context) + 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Varslinger',
              style: OnlineTheme.header(),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: eventCategories.keys.map((String key) {
              return Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: OnlineTheme.buttonRadius,
                ),
                color: OnlineTheme.grayBorder,
                child: CheckboxListTile(
                  title: Text(key, style: OnlineTheme.subHeader()),
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
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Bekreftelser',
              style: OnlineTheme.header(),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: confirmations.keys.map((String key) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                color: OnlineTheme.grayBorder,
                child: CheckboxListTile(
                  title: Text(key, style: OnlineTheme.subHeader()),
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
