import 'package:flutter/material.dart';

import '../../main.dart';
import '../login/login_page.dart';
import '/components/animated_button.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/pages/profile/profile_page.dart';
import '/services/app_navigator.dart';
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

class SettingsPage extends ScrollablePage {
  const SettingsPage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Padding(
      padding: padding,
      child: _SettingsContent(),
    );
  }
}

class _SettingsContent extends StatefulWidget {
  @override
  __SettingsContentState createState() => __SettingsContentState();
}

Map<String, bool> confirmations = {
  'Påmelding': false,
  'Avmelding': true,
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
          const SizedBox(
            height: 24,
          ),
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
                      height: OnlineTheme.buttonHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: OnlineTheme.green.withOpacity(0.4),
                        borderRadius: OnlineTheme.buttonRadius,
                        border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.green, width: 2)),
                      ),
                      child: Center(
                        child: Text(
                          'Lagre',
                          style: OnlineTheme.textStyle(weight: 5, color: OnlineTheme.green),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
