import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
          OnlineCard(
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              tilePadding: EdgeInsets.zero,
              title: Text("Hjelp og støtte", style: OnlineTheme.textStyle()),
              leading: ThemedIcon(icon: IconType.users, size: 24),
              trailing: ThemedIcon(icon: IconType.downArrow, size: 24),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        AnimatedButton(onTap: () {
                          AppNavigator.navigateToPage(const InfoPage());
                        }, childBuilder: (context, hover, pointerDown) {
                          return Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: OnlineTheme.current.fg,
                              ),
                              const SizedBox(
                                width: 17,
                              ),
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
                      height: 32,
                    ),
                    Row(
                      children: [
                        AnimatedButton(onTap: () {
                          io.Client.launchInBrowser('https://forms.gle/xUTTN95CuWtSbNCS7');
                        }, childBuilder: (context, hover, pointerDown) {
                          return Row(
                            children: [
                              Icon(
                                Icons.bug_report_outlined,
                                color: OnlineTheme.current.fg,
                              ),
                              const SizedBox(width: 17),
                              Text(
                                "Rapporter en bug",
                                style: OnlineTheme.textStyle(),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          OnlineCard(
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              tilePadding: EdgeInsets.zero,
              title: Text("Innstillinger og personvern", style: OnlineTheme.textStyle()),
              leading: ThemedIcon(icon: IconType.settings, size: 24),
              trailing: ThemedIcon(icon: IconType.downArrow, size: 24),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    AnimatedButton(onTap: () {
                      io.Client.launchInBrowser('https://online.ntnu.no/profile/settings/userdata');
                    }, childBuilder: (context, hover, pointerDown) {
                      return Row(
                        children: [
                          ThemedIcon(
                            icon: IconType.download,
                            size: 18,
                          ),
                          const SizedBox(width: 22),
                          Text(
                            "Last ned brukerdata",
                            style: OnlineTheme.textStyle(),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 32),
                    AnimatedButton(onTap: () {
                      initiateDeletion(context);
                    }, childBuilder: (context, hover, pointerDown) {
                      return Row(
                        children: [
                          ThemedIcon(
                            icon: IconType.trash,
                            size: 20,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "Slett brukerdata",
                            style: OnlineTheme.textStyle(),
                          ),
                        ],
                      );
                    }),
                  ],
                )
              ],
            ),
          ),
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
