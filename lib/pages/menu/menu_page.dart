import 'package:accordion/accordion.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../profile/delete_user.dart';
import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart' as io;
import '/core/models/user_model.dart';
import '/pages/event/cards/event_card.dart';
import '/pages/home/info_page.dart';
import '/pages/menu/profile_card.dart';
import '/pages/menu/settings.dart';
import '/services/app_navigator.dart';
import '/services/authenticator.dart';
import '/services/env.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';

class Foldout extends StatefulWidget {
  final Widget? leading;
  final Widget? trailing;
  final String title;
  final List<Widget> children;

  const Foldout({
    super.key,
    required this.title,
    required this.children,
    this.leading,
    this.trailing,
  });

  @override
  State<StatefulWidget> createState() => FoldoutState();
}

class FoldoutState extends State<Foldout> {
  bool open = false;

  Widget header() {
    return Listener(
      onPointerUp: (event) {
        setState(() {
          open = !open;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.leading != null) widget.leading!,
          Expanded(child: Text(widget.title, style: OnlineTheme.textStyle())),
          AnimatedRotation(
            turns: open ? -0.5 : 0,
            duration: Duration(milliseconds: 100),
            child: widget.trailing ??
                Lucide(
                  LucideIcon.chevronDown,
                  size: 20,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header(),
        ClipRect(
          child: AnimatedAlign(
            alignment: open ? Alignment.topCenter : Alignment.topCenter,
            heightFactor: open ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Column(
              children: widget.children,
            ),
          ),
        ),
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

  void initiateDeletion(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      showCupertinoDialog(context: context, builder: (context) => cupertionDeleteDialog());
    } else {
      showDialog(context: context, builder: (context) => materialDeleteDialog());
    }
  }

  Widget cupertionDeleteDialog() {
    return CupertinoAlertDialog(
      title: const Text('Bekreft sletting'),
      content: const Text('Er du sikker på at du vil slette brukerdataene dine?'),
      actions: [
        CupertinoDialogAction(
          child: const Text('Avbryt'),
          onPressed: () {
            AppNavigator.pop();
          },
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: delete,
          child: const Text('Slett'),
        ),
      ],
    );
  }

  Widget materialDeleteDialog() {
    return AlertDialog(
      title: const Text('Bekreft sletting'),
      content: const Text('Er du sikker på at du vil slette brukerdataene dine?'),
      actions: [
        TextButton(
          onPressed: () {
            AppNavigator.pop();
          },
          child: const Text('Avbryt'),
        ),
        TextButton(
          onPressed: delete,
          child: const Text('Slett'),
        ),
      ],
    );
  }

  void delete() {
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
      child: Foldout(
        title: "Hjelp og Støtte",
        leading: Padding(padding: EdgeInsets.only(right: 16), child: Lucide(LucideIcon.users, size: 24)),
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
                AppNavigator.navigateToPage(const InfoPage());
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
      child: Foldout(
        title: 'Din Data',
        leading: Padding(padding: EdgeInsets.only(right: 16), child: Lucide(LucideIcon.database, size: 24)),
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
      padding: padding,
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
