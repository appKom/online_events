import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online/components/navbar.dart';
import 'package:online/components/skeleton_loader.dart';
import 'package:online/pages/event/cards/event_card.dart';
import 'package:online/pages/login/login_page.dart';
import 'package:online/theme/themed_icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../pixel/models/pixel_user_class.dart';
import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/core/client/client.dart' as io;
import '/core/models/user_model.dart';
import '/pages/profile/delete_user.dart';
import '/services/app_navigator.dart';
import '/services/authenticator.dart';
import '/theme/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Storage storage;
  File? _imageFile;
  late Databases database;
  PixelUserClass? pixelUserData;
  UserModel? theUser;

  @override
  void initState() {
    super.initState();
    if (io.Client.userCache.value != null) {
      theUser = io.Client.userCache.value!;
      return;
    }
    fetchUserProfile();

    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject(dotenv.env['PROJECT_ID']);

    storage = Storage(client);
    database = Databases(client);

    final userModel = io.Client.userCache.value;

    fetchPixelUserInfo(userModel).then((userData) {
      if (userData != null) {
        setState(() {
          pixelUserData = userData;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchUserProfile() async {
    UserModel? profile = await io.Client.getUserProfile();
    if (profile != null && mounted) {
      setState(() {
        theUser = profile;
      });

      await saveUserProfileToDatabase(profile);
    }
  }

  Future<void> saveUserProfileToDatabase(UserModel? userModel) async {
    if (userModel == null) return;

    try {
      await database.createDocument(
        collectionId: dotenv.env['USER_COLLECTION_ID']!,
        databaseId: dotenv.env['USER_DATABASE_ID']!,
        documentId: userModel.username,
        data: {
          'username': userModel.username,
          'id': userModel.id,
          'first_name': userModel.firstName,
          'last_name': userModel.lastName,
          'ntnuUsername': userModel.ntnuUsername,
          'year': userModel.year
        },
      );
    } catch (e) {
      print("Error saving UserProfile: $e");
    }
  }

  Future<PixelUserClass?> fetchPixelUserInfo(UserModel? userModel) async {
    if (userModel == null) return null;

    try {
      final response = await database.getDocument(
        collectionId: dotenv.env['USER_COLLECTION_ID']!,
        documentId: userModel.username,
        databaseId: dotenv.env['USER_DATABASE_ID']!,
      );
      return PixelUserClass.fromJson(response.data);
    } catch (e) {
      print('Error fetching document data: $e');
    }
    return null;
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

  Future<void> pickImage(ImageSource source) async {
    // TODO: Re-implement image picker with new version of image cropper
    // try {
    //   final ImagePicker picker = ImagePicker();
    //   final XFile? pickedFile = await picker.pickImage(source: source);

    //   if (pickedFile != null) {
    //     CroppedFile? croppedFile = await ImageCropper().cropImage(
    //       sourcePath: pickedFile.path,
    //       aspectRatioPresets: [
    //         CropAspectRatioPreset.square,
    //       ],
    //       uiSettings: [
    //         AndroidUiSettings(
    //             toolbarTitle: 'Cropper',
    //             toolbarColor: Colors.deepOrange,
    //             toolbarWidgetColor: Colors.white,
    //             initAspectRatio: CropAspectRatioPreset.original,
    //             lockAspectRatio: false),
    //         IOSUiSettings(
    //           title: 'Cropper',
    //         ),
    //       ],
    //     );

    //     setState(() {
    //       if (croppedFile != null) {
    //         _imageFile = File(croppedFile.path);
    //       }
    //     });
    //   }
    // } catch (e) {
    //   // Handle exceptions related to image picker or cropper
    //   print('Error picking and cropping image: $e');
    // }
  }

  Future<void> uploadImage(UserModel? userModel) async {
    if (userModel == null) return;
    if (_imageFile == null) return;

    String fileName = userModel.username;

    try {
      await storage.getFile(
        bucketId: dotenv.env['USER_BUCKET_ID']!,
        fileId: fileName,
      );

      await storage.deleteFile(
        bucketId: dotenv.env['USER_BUCKET_ID']!,
        fileId: fileName,
      );
    } catch (e) {
      // TODO: Should probaly handle
    }

    try {
      final file = await storage.createFile(
        bucketId: dotenv.env['USER_BUCKET_ID']!,
        fileId: fileName,
        file: InputFile.fromPath(path: _imageFile!.path, filename: fileName),
      );

      print("Image uploaded successfully: $file");
      setState(() {
        //hei
      });
      AppNavigator.replaceWithPage(const ProfilePageDisplay());
    } catch (e) {
      print("Error uploading image: $e");
    }
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
    setState(() {
      // TODO: Test this
      Authenticator.logout();
    });
    AppNavigator.replaceWithPage(
      const DeleteUserDisplay(),
    );
  }

  Widget profilePicture(UserModel? user) {
    if (user == null) {
      return SkeletonLoader(
        height: 150,
        width: 150,
        borderRadius: BorderRadius.circular(75),
      );
    }

    if (Platform.isIOS && acceptedPrivacy.value) {
      return ClipOval(
        child: SizedBox(
          width: 150,
          height: 150,
          child: _imageFile != null
              ? Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                )
              : CachedNetworkImage(
                  imageUrl:
                      'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['USER_BUCKET_ID']}/files/${user.username}/view?project=${dotenv.env['PROJECT_ID']}&mode=public',
                  fit: BoxFit.cover,
                  height: 240,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/default_profile_picture.png',
                    fit: BoxFit.cover,
                    height: 240,
                  ),
                ),
        ),
      );
    } else {
      return ClipOval(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Image.asset(
            'assets/images/default_profile_picture.png',
            fit: BoxFit.cover,
            height: 240,
          ),
        ),
      );
    }
  }

  void editProfile() {
    launchUrl(
      Uri.parse('https://old.online.ntnu.no/profile/edit/'),
      mode: LaunchMode.externalApplication,
    );
  }

  Widget profileHeader(UserModel? user) {
    if (user == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SkeletonLoader(width: 100, height: 24, borderRadius: BorderRadius.circular(5)),
          const SizedBox(width: 10),
          SkeletonLoader(width: 100, height: 24, borderRadius: BorderRadius.circular(5)),
        ],
      );
    }

    return Center(
      child: Text(
        '${user.firstName} ${user.lastName}',
        style: OnlineTheme.header(),
      ),
    );
  }

  Widget bioCard(UserModel? user) {
    late final Widget content;

    if (user == null) {
      content = SkeletonLoader(
        height: 40,
        borderRadius: BorderRadius.circular(5),
      );
    } else {
      content = Text(
        user.bio ?? 'Klikk for å legge til bio',
        style: OnlineTheme.textStyle(),
      );
    }

    return AnimatedButton(
      onTap: editProfile,
      childBuilder: (context, hover, pointerDown) {
        return OnlineCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _editHeader('Biografi'),
              const SizedBox(height: 16),
              content,
            ],
          ),
        );
      },
    );
  }

  Widget contactCard(UserModel? user) {
    late final List<Widget> content;

    if (user == null) {
      content = List.generate(3, (_) => _propertySkeleton());
    } else {
      content = [
        constValueTextInput('Brukernavn', user.username),
        constValueTextInput('Telefon', user.phoneNumber ?? ''),
        constValueTextInput('E-post', user.email),
      ];
    }

    return OnlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 32,
            child: Text('Kontakt', style: OnlineTheme.header()),
          ),
          const SizedBox(height: 16),
          ...content,
        ],
      ),
    );
  }

  Widget studyCard(UserModel? user) {
    late final List<Widget> content;

    if (user == null) {
      content = List.generate(2, (_) => _propertySkeleton());
    } else {
      content = [
        constValueTextInput('Klassetrinn', user.year.toString()),
        constValueTextInput('Startår', user.startedDate!.year.toString()),
      ];
    }

    return OnlineCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 32,
            child: Text('Studie', style: OnlineTheme.header()),
          ),
          const SizedBox(height: 16),
          ...content,
          const Separator(margin: 24),
          studyCourse(user),
        ],
      ),
    );
  }

  Widget studyCourse(UserModel? user) {
    Widget stage(String header, int count, int progress) {
      return Expanded(
        flex: count,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 32,
              child: Center(
                child: Text(
                  header,
                  style: OnlineTheme.subHeader(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                count,
                (i) {
                  final color = i < progress ? OnlineTheme.current.primary : OnlineTheme.current.muted;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        height: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    if (user == null) {
      return Row(
        children: [
          stage('Bachelor', 3, 0),
          stage('Master', 2, 0),
          stage('PhD', 1, 0),
        ],
      );
    }

    return Row(
      children: [
        stage('Bachelor', 3, user.year),
        stage('Master', 2, user.year - 3),
        stage('PhD', 1, user.year - 5),
      ],
    );
  }

  Widget _editHeader(String header) {
    return SizedBox(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            header,
            style: OnlineTheme.header(),
          ),
          ThemedIcon(icon: IconType.userEdit, size: 18),
        ],
      ),
    );
  }

  Widget _propertySkeleton() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SkeletonLoader(width: 100, height: 24, borderRadius: BorderRadius.circular(5)),
          SkeletonLoader(width: 150, height: 24, borderRadius: BorderRadius.circular(5)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return FutureBuilder(
      future: appTrackingPermission(isIos),
      builder: (context, privacySnapshot) {
        return RefreshIndicator(
          onRefresh: () async {
            fetchUserProfile();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  profileHeader(theUser),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: ValueListenableBuilder(
                        valueListenable: acceptedPrivacy,
                        builder: (context, accepted, child) {
                          return AnimatedButton(
                            onTap: () async {
                              if (!accepted) return;

                              await pickImage(ImageSource.gallery);
                              if (_imageFile != null) {
                                await uploadImage(theUser);
                              }
                            },
                            childBuilder: (context, hover, pointerDown) {
                              return profilePicture(theUser);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  bioCard(theUser),
                  const SizedBox(height: 24),
                  contactCard(theUser),
                  const SizedBox(height: 24),
                  studyCard(theUser),
                  // const SizedBox(height: 24),
                  // const SettingsPage(),
                  const SizedBox(height: 24 + 24),
                  Row(
                    children: [
                      Expanded(
                        child: AnimatedButton(
                          onTap: () async {
                            await Authenticator.logout();
                            // AppNavigator.replaceWithPage(const LoginPage());
                            Navbar.navigateTo(NavbarPage.home);
                          },
                          childBuilder: (context, hover, pointerDown) {
                            final theme = OnlineTheme.current;

                            return Container(
                              height: OnlineTheme.buttonHeight,
                              decoration: BoxDecoration(
                                color: theme.primaryBg,
                                borderRadius: OnlineTheme.buttonRadius,
                                border: Border.fromBorderSide(
                                  BorderSide(color: theme.primary, width: 2),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Logg Ut',
                                  style: OnlineTheme.textStyle(weight: 5, color: theme.primaryFg),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget constValueTextInput(String label, String value) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: OnlineTheme.textStyle(),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                value,
                style: OnlineTheme.textStyle(
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePageDisplay extends StaticPage {
  const ProfilePageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return const ProfilePage();
  }
}
