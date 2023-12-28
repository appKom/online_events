import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/core/client/client.dart' as io;
import '/core/models/user_model.dart';
import '/main.dart';
import '/pages/home/home_page.dart';
import '/pages/loading/loading_display_page.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import '/theme/themed_icon_button.dart';
import 'package:appwrite/appwrite.dart';

int userId = 0;
UserModel? userProfile;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Storage storage;
  bool showInfoAboutPicture = false;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();

    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('65706141ead327e0436a');

    storage = Storage(client);
  }

  Future<void> fetchUserProfile() async {
    UserModel? profile = await io.Client.getUserProfile();
    if (profile != null) {
      setState(() {
        userProfile = profile;
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
  final ImagePicker picker = ImagePicker();

  try {
    final XFile? pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print("No image was selected");
      }
    });
  } catch (e) {
    print("Error picking image: $e");

    setState(() {
    });
  }
}

  Future<void> uploadImage() async {
    if (_imageFile == null) {
      print("No image selected");
      return;
    }

    String fileName = userProfile?.ntnuUsername ?? 'default' + '.jpg';

    try {
      await storage.getFile(
        bucketId: '658996fac01c08570158',
        fileId: fileName,
      );

      await storage.deleteFile(
        bucketId: '658996fac01c08570158',
        fileId: fileName,
      );
    } catch (e) {
      //Should probaly handle
    }

    try {
      final file = await storage.createFile(
        bucketId: '658996fac01c08570158',
        fileId: fileName,
        file: InputFile.fromPath(path: _imageFile!.path, filename: fileName),
      );

      print("Image uploaded successfully: $file");
      setState(() {
        //hei
      });
      PageNavigator.navigateTo(const DummyDisplay());
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    const aboveBelowPadding = EdgeInsets.only(top: 16, bottom: 16);
    final headerStyle = OnlineTheme.textStyle(size: 20, weight: 7);
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    if (userProfile != null) {
      userId = userProfile!.id;
    }

    if (userProfile != null) {
      return Scaffold(
        backgroundColor: OnlineTheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: padding.left, right: padding.right),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: OnlineHeader.height(context) + 40),
                Center(
                  child: Text(
                    '${userProfile!.firstName} ${userProfile!.lastName}',
                    style: OnlineTheme.textStyle(
                      size: 20,
                      weight: 7,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: AnimatedButton(
                      onTap: () async {
                        await pickImage(ImageSource.gallery);
                        if (_imageFile != null) {
                          await uploadImage();
                        }
                      },
                      childBuilder: (context, hover, pointerDown) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 125,
                                height: 125,
                                child: _imageFile != null
                                    ? Image.file(
                                        _imageFile!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        'https://cloud.appwrite.io/v1/storage/buckets/658996fac01c08570158/files/${userProfile?.ntnuUsername ?? 'default'}/view?project=65706141ead327e0436a&mode=public',
                                        fit: BoxFit.cover,
                                        height: 240,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            if (!showInfoAboutPicture) {
                                              setState(() {
                                                showInfoAboutPicture = true;
                                              });
                                            }
                                          });
                                          return Image.asset(
                                            'assets/images/default_profile_picture.png',
                                            fit: BoxFit.cover,
                                            height: 240,
                                          );
                                        },
                                      ),
                              ),
                            ),
                            if (showInfoAboutPicture)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                    'Trykk for å laste opp profil bilde',
                                    style: OnlineTheme.textStyle(
                                        color: OnlineTheme.blue2)),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Kontakt',
                  style: headerStyle,
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: aboveBelowPadding,
                  child: constValueTextInput(
                      'NTNU-brukernavn', userProfile!.ntnuUsername),
                ),
                // const Separator(),
                Padding(
                  padding: aboveBelowPadding,
                  child:
                      constValueTextInput('Telefon', userProfile!.phoneNumber),
                ),
                // const Separator(),
                Padding(
                  padding: aboveBelowPadding,
                  child: constValueTextInput('E-post', userProfile!.email),
                ),
                const Separator(margin: 40),
                Text(
                  'Studie',
                  style: headerStyle,
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: aboveBelowPadding,
                  child: constValueTextInput(
                      'Klassetrinn', userProfile!.year.toString()),
                ),
                Padding(
                  padding: aboveBelowPadding,
                  child: constValueTextInput(
                      'Startår', userProfile!.startedDate.year.toString()),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: Text(
                            'Bachelor',
                            style: OnlineTheme.textStyle(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            'Master',
                            style: OnlineTheme.textStyle(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'PhD',
                            style: OnlineTheme.textStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: CustomPaint(
                    painter:
                        StudyCoursePainter(year: userProfile!.year.toDouble()),
                  ),
                ),
                const Separator(margin: 40),
                Text(
                  'Eksterne sider',
                  style: headerStyle,
                ),
                Padding(
                  padding: aboveBelowPadding,
                  child:
                      constValueTextInput('Github', userProfile!.github ?? ''),
                ),
                Padding(
                  padding: aboveBelowPadding,
                  child: constValueTextInput(
                      'Linkedin', userProfile!.linkedin ?? ''),
                ),
                Padding(
                    padding: aboveBelowPadding,
                    child: constValueTextInput(
                        'Hjemmeside', userProfile!.website ?? '')),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: AnimatedButton(
                    onTap: () {
                      loggedIn = false;
                      PageNavigator.navigateTo(const HomePage());
                    },
                    childBuilder: (context, hover, pointerDown) {
                      return Container(
                        height: OnlineTheme.buttonHeight,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              OnlineTheme.red1, // Start color
                              Color.fromARGB(255, 255, 132, 95), // End color
                            ],
                          ),
                          borderRadius: OnlineTheme.buttonRadius,
                        ),
                        child: Center(
                          child: Text(
                            'Logg Ut',
                            style: OnlineTheme.textStyle(weight: 5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Navbar.height(context)),
              ],
            ),
          ),
        ),
      );
    } else {
      return const LoadingPageDisplay();
    }
  }

  Widget constValueTextInput(String label, String value) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: OnlineTheme.textStyle(),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: OnlineTheme.gray14,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Stack(children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: OnlineTheme.textStyle(
                        height: 1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 40,
                  child: ThemedIconButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Clipboard.setData(ClipboardData(text: value));
                    },
                    size: 16,
                    icon: IconType.copy,
                    color: const Color(0xFF4C566A),
                    hoverColor: OnlineTheme.white,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget textInput(String label, String placeholder) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: OnlineTheme.textStyle(color: OnlineTheme.gray11),
            ),
          ),
          Expanded(
            child: TextField(
              cursorColor: OnlineTheme.gray8,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: OnlineTheme.textStyle(
                  color: const Color(0xFF4C566A),
                  height: 1,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: const BorderSide(color: Color(0xFF4C566A)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: const BorderSide(color: OnlineTheme.white),
                ),
                filled: true,
                fillColor: OnlineTheme.gray0,
              ),
              style: OnlineTheme.textStyle(
                color: OnlineTheme.white,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudyCoursePainter extends CustomPainter {
  final double year;

  StudyCoursePainter({super.repaint, required this.year});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final cy = size.height / 2; // Center Y

    final fraction = size.width / 6;
    final segment1 = fraction * 3 - 18;
    final segment2 = fraction * 2 + 9;

    final c1 = Offset(18, cy);
    final c2 = Offset(9 + (segment1 - 36) / 2, cy);
    final c3 = Offset((segment1 - 36), cy);

    final c4 = Offset(segment1 + 36, cy);
    final c5 = Offset(segment1 + segment2 - 36, cy);

    final c6 = Offset(size.width - 18, cy);

    line(year >= 1, c1, c2, canvas, paint);
    circle(year >= 1, c1, canvas, paint);
    line(year > 2, c2, c3, canvas, paint);
    circle(year > 1, c2, canvas, paint);
    line(year > 3, c3, Offset(segment1, cy), canvas, paint);
    circle(year > 2, c3, canvas, paint);

    line(year > 3, Offset(segment1, 0), Offset(segment1, size.height), canvas,
        paint);

    line(year >= 4, Offset(segment1 + 1.5, cy), c4, canvas, paint);
    line(year >= 5, c4, c5, canvas, paint);
    circle(year > 4, c4, canvas, paint);
    line(year > 5, c5, Offset(segment1 + segment2, cy), canvas, paint);
    circle(year >= 5, c5, canvas, paint);

    line(year > 5, Offset(segment1 + segment2, 0),
        Offset(segment1 + segment2, size.height), canvas, paint);

    line(year >= 6, Offset(segment1 + segment2 + 1.5, cy), c6, canvas, paint);
    circle(year >= 6, c6, canvas, paint);
  }

  void line(bool active, Offset start, Offset end, Canvas canvas, Paint paint) {
    final color = active ? green : gray;
    paint.color = color;
    canvas.drawLine(start, end, paint);
  }

  // static const gray = Color(0xFF153E75);
  static const gray = OnlineTheme.gray0;
  static const green = Color(0xFF36B37E);

  void circle(bool active, Offset c, Canvas canvas, Paint paint) {
    final color = active ? green : gray;

    paint.color = OnlineTheme.background;
    paint.style = PaintingStyle.fill;

    canvas.drawCircle(c, 15, paint);

    paint.color = color;
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(c, 16, paint);

    paint.style = PaintingStyle.fill;
    canvas.drawCircle(c, 8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ProfilePageDisplay extends StaticPage {
  const ProfilePageDisplay({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const ProfilePage();
  }
}

class DummyDisplay extends StaticPage {
  const DummyDisplay({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const ProfilePage();
  }
}
