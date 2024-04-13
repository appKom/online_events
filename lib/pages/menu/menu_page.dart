import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/pages/event/cards/event_card.dart';
import 'package:online/pages/home/info_page.dart';
import 'package:online/pages/menu/profile_card.dart';
import 'package:online/pages/profile/settings.dart';

import '../../components/animated_button.dart';
import '../../components/navbar.dart';
import '../../core/client/client.dart' as io;
import '../../core/models/user_model.dart';
import '../../services/app_navigator.dart';
import '../../services/authenticator.dart';
import '../../theme/theme.dart';
import '../profile/delete_user.dart';
import '../profile/profile_page.dart';

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

    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject(dotenv.env['PROJECT_ID']);

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
        collectionId: dotenv.env['USER_COLLECTION_ID']!,
        documentId: userModel.username,
        databaseId: dotenv.env['USER_DATABASE_ID']!,
      );
    } catch (e) {
      print('Error fetching document data: $e');
    }

    await storage.getFile(
      bucketId: dotenv.env['USER_BUCKET_ID']!,
      fileId: fileName,
    );

    await storage.deleteFile(
      bucketId: dotenv.env['USER_BUCKET_ID']!,
      fileId: fileName,
    );
  }

  Future login() async {
    final response = await Authenticator.login();

    if (response != null) {
      AppNavigator.replaceWithPage(const ProfilePageDisplay());
      NavbarState.setActiveMenu();
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;
    return Padding(
      padding: padding,
      child: SingleChildScrollView(
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
                title: Text("Hjelp og støtte", style: OnlineTheme.textStyle()),
                leading: SvgPicture.asset("assets/icons/help.svg", color: OnlineTheme.white),
                trailing: SvgPicture.asset("assets/icons/down_arrow.svg", color: OnlineTheme.white),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const SizedBox(
                            width: 57,
                          ),
                          AnimatedButton(onTap: () {
                            AppNavigator.navigateToPage(const InfoPage());
                          }, childBuilder: (context, hover, pointerDown) {
                            return Text(
                              "Om Online Appen",
                              style: OnlineTheme.textStyle(),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 57,
                          ),
                          AnimatedButton(onTap: () {
                            io.Client.launchInBrowser('https://forms.gle/xUTTN95CuWtSbNCS7');
                          }, childBuilder: (context, hover, pointerDown) {
                            return Text(
                              "Rapporter en bug",
                              style: OnlineTheme.textStyle(),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            OnlineCard(
              child: ExpansionTile(
                title: Text("Innstillinger og personvern", style: OnlineTheme.textStyle()),
                leading: SvgPicture.asset("assets/icons/settings.svg", color: OnlineTheme.white),
                trailing: SvgPicture.asset("assets/icons/down_arrow.svg", color: OnlineTheme.white),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 57,
                          ),
                          AnimatedButton(onTap: () {
                            io.Client.launchInBrowser('https://online.ntnu.no/profile/settings/userdata');
                          }, childBuilder: (context, hover, pointerDown) {
                            return Text(
                              "Last ned brukerdata",
                              style: OnlineTheme.textStyle(),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 57,
                          ),
                          AnimatedButton(onTap: () {
                            initiateDeletion(context);
                          }, childBuilder: (context, hover, pointerDown) {
                            return Text(
                              "Slett brukerdata",
                              style: OnlineTheme.textStyle(),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            if (Authenticator.isLoggedIn())
              SizedBox(
                height: 40,
                child: Expanded(
                  child: AnimatedButton(
                    onTap: () async {
                      await Authenticator.logout();
                      // AppNavigator.replaceWithPage(const LoginPage());
                      Navbar.navigateTo(NavbarPage.home);
                    },
                    childBuilder: (context, hover, pointerDown) {
                      return Container(
                        height: OnlineTheme.buttonHeight,
                        decoration: BoxDecoration(
                          color: OnlineTheme.yellow.darken(40),
                          borderRadius: OnlineTheme.buttonRadius,
                          border: const Border.fromBorderSide(
                            BorderSide(color: OnlineTheme.yellow, width: 2),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Logg Ut',
                            style: OnlineTheme.textStyle(weight: 5, color: OnlineTheme.yellow),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            if (!Authenticator.isLoggedIn())
              SizedBox(
                height: 40,
                child: Expanded(
                  child: AnimatedButton(
                    onTap: () async {
                      login();
                    },
                    childBuilder: (context, hover, pointerDown) {
                      return Container(
                        height: OnlineTheme.buttonHeight,
                        decoration: BoxDecoration(
                          color: OnlineTheme.green.darken(40),
                          borderRadius: OnlineTheme.buttonRadius,
                          border: const Border.fromBorderSide(
                            BorderSide(color: OnlineTheme.green, width: 2),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Logg Inn',
                            style: OnlineTheme.textStyle(weight: 5, color: OnlineTheme.green),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
