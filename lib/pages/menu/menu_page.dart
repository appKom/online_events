import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:native_ios_dialog/native_ios_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart' as io;
import '/core/models/user_model.dart';
import '/pages/event/cards/event_card.dart';
import '/pages/menu/profile_card.dart';
import '/pages/menu/settings.dart';
import '/services/app_navigator.dart';
import '/services/authenticator.dart';
import '/services/env.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import '../profile/delete_user.dart';

class Foldout extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final List<Widget> children;

  final EdgeInsets? headerPadding;
  final EdgeInsets? contentPadding;
  final bool open;

  const Foldout({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.trailing,
    this.headerPadding,
    this.contentPadding,
    this.open = false,
  });

  @override
  State<StatefulWidget> createState() => FoldoutState();
}

class FoldoutState extends State<Foldout> {
  bool open = false;

  @override
  void initState() {
    super.initState();
    open = widget.open;
  }

  Widget header() {
    return Listener(
      onPointerUp: (event) {
        setState(() {
          open = !open;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: widget.headerPadding ?? EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (widget.leading != null) widget.leading!,
            Expanded(child: Text(widget.title, style: OnlineTheme.textStyle())),
            AnimatedRotation(
              turns: open ? 0.5 : 0,
              duration: Duration(milliseconds: 100),
              child: widget.trailing ??
                  Lucide(
                    LucideIcon.chevronDown,
                    size: 20,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget content() {
    return ClipRect(
      child: AnimatedAlign(
        alignment: open ? Alignment.topCenter : Alignment.topCenter,
        heightFactor: open ? 1.0 : 0.0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Padding(
          padding: widget.contentPadding ?? EdgeInsets.zero,
          child: Column(
            children: widget.children,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header(),
        content(),
      ],
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  late Storage storage;
  late Databases database;
  UserModel? theUser;

  @override
  void initState() {
    super.initState();

    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject(Env.get('PROJECT_ID'));

    storage = Storage(client);
    database = Databases(client);
  }

  Future<void> initiateDeletion(BuildContext context) async {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final result = await FlutterPlatformAlert.showCustomAlert(
      windowTitle: 'Bekreft sletting',
      text: 'Er du sikker på at du vil slette brukerdataene dine?',
      iconStyle: IconStyle.warning,
      negativeButtonTitle: 'Slett',
      neutralButtonTitle: 'Avbryt',
      options: PlatformAlertOptions(
        windows: WindowsAlertOptions(preferMessageBox: true),
      ),
    );

    if (result == CustomButton.negativeButton) {
      deleteUserData();
    }
  }

  void deleteUserData() {
    final userInfo = io.Client.userCache.value;

    if (userInfo == null) return;

    AppNavigator.pop();
    deletePixelUserInfo(userInfo);
    Authenticator.logout();
    AppNavigator.replaceWithPage(
      const DeleteUserDisplay(),
    );
  }

  Future<void> deletePixelUserInfo(UserModel? userModel) async {
    if (userModel == null) return;

    String fileName = userModel.username;
    try {
      await database.deleteDocument(
        collectionId: Env.get('USER_COLLECTION_ID'),
        documentId: userModel.username,
        databaseId: Env.get('USER_DATABASE_ID'),
      );
    } catch (e) {
      print('Error fetching document data: $e');
    }

    await storage.getFile(
      bucketId: Env.get('USER_BUCKET_ID'),
      fileId: fileName,
    );

    await storage.deleteFile(
      bucketId: Env.get('USER_BUCKET_ID'),
      fileId: fileName,
    );
  }

  Widget helpAndSupportCard() {
    return OnlineCard(
      padding: EdgeInsets.all(8),
      child: Foldout(
        title: "Hjelp og Støtte",
        leading: Padding(padding: EdgeInsets.only(right: 16), child: Lucide(LucideIcon.users, size: 24)),
        headerPadding: EdgeInsets.all(16),
        contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              AnimatedButton(onTap: () {
                final url = Uri.parse(_helpUrl);
                launchUrl(url);
              }, childBuilder: (context, hover, pointerDown) {
                return Row(
                  children: [
                    Lucide(
                      LucideIcon.user,
                      size: 20,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Opplevd noe ugreit?",
                      style: OnlineTheme.textStyle(),
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              AnimatedButton(onTap: () {
                context.go('/menu/info');
              }, childBuilder: (context, hover, pointerDown) {
                return Row(
                  children: [
                    Lucide(
                      LucideIcon.notebook,
                      size: 20,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Om Online Appen",
                      style: OnlineTheme.textStyle(),
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              AnimatedButton(
                onTap: () {
                  io.Client.launchInBrowser('https://forms.gle/xUTTN95CuWtSbNCS7');
                },
                childBuilder: (context, hover, pointerDown) {
                  return Row(
                    children: [
                      Lucide(
                        LucideIcon.bug,
                        size: 20,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Rapporter en bug",
                        style: OnlineTheme.textStyle(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget settingsAndPrivacyCard() {
    return OnlineCard(
      padding: EdgeInsets.all(8),
      child: Foldout(
        title: 'Din Data',
        leading: Padding(padding: EdgeInsets.only(right: 16), child: Lucide(LucideIcon.database, size: 24)),
        headerPadding: EdgeInsets.all(16),
        contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          const SizedBox(height: 16),
          AnimatedButton(onTap: () {
            io.Client.launchInBrowser('https://online.ntnu.no/profile/settings/userdata');
          }, childBuilder: (context, hover, pointerDown) {
            return Row(
              children: [
                Lucide(
                  LucideIcon.download,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Text(
                  "Last ned brukerdata",
                  style: OnlineTheme.textStyle(),
                ),
              ],
            );
          }),
          const SizedBox(height: 24),
          AnimatedButton(onTap: () {
            initiateDeletion(context);
          }, childBuilder: (context, hover, pointerDown) {
            return Row(
              children: [
                Lucide(
                  LucideIcon.trash,
                  size: 20,
                ),
                const SizedBox(width: 16),
                Text(
                  "Slett brukerdata",
                  style: OnlineTheme.textStyle(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  static const _helpUrl =
      "https://docs.google.com/forms/d/e/1FAIpQLScvjEqVsiRIYnVqCNqbH_-nmYk3Ux6la8a7KZzsY3sJDbW-iA/viewform";

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    return Padding(
      padding: padding + EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          const ProfileCard(),
          const SizedBox(
            height: 24,
          ),
          const SettingsPage(),
          const SizedBox(height: 24),
          helpAndSupportCard(),
          const SizedBox(
            height: 24,
          ),
          settingsAndPrivacyCard(),
          const SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }
}

class MenuPageDisplay extends ScrollablePage {
  const MenuPageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return const MenuPage();
  }
}
