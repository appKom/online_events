import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

import '../pixel/models/pixel_user_class.dart';
import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/components/skeleton_loader.dart';
import '/core/client/client.dart' as io;
import '/core/models/user_model.dart';
import '/main.dart';
import '/pages/home/home_page.dart';
import '/pages/loading/loading_display_page.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Storage storage;
  bool showInfoAboutPicture = false;
  File? _imageFile;
  late Databases database;
  final TextEditingController _titleController = TextEditingController();
  PixelUserClass? pixelUserData;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();

    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject(dotenv.env['PROJECT_ID']);

    storage = Storage(client);
    database = Databases(client);

    fetchPixelUserInfo().then((userData) {
      print(userData);
      if (userData != null) {
        setState(() {
          pixelUserData = userData;
        });
      }
    });
  }

  Future<void> fetchUserProfile() async {
    UserModel? profile = await io.Client.getUserProfile();
    if (profile != null) {
      setState(() {
        userProfile = profile;
      });

      await saveUserProfileToDatabase();
    }
  }

  Future<void> saveUserProfileToDatabase() async {
    if (userProfile == null) {
      print("UserProfile is null");
      return;
    }

    try {
      await database.createDocument(
          collectionId: dotenv.env['USER_COLLECTION_ID']!,
          databaseId: dotenv.env['USER_DATABASE_ID']!,
          documentId: userProfile!.username,
          data: {
            'username': userProfile!.username,
            'id': userProfile!.id,
            'first_name': userProfile!.firstName,
            'last_name': userProfile!.lastName,
            'ntnuUsername': userProfile!.ntnuUsername,
            'year': userProfile!.year
          });
      print("UserProfile saved successfully");
    } catch (e) {
      print("Error saving UserProfile: $e");
    }
  }

  Future<void> saveBiography() async {
    if (userProfile == null && _titleController.text.isNotEmpty) {
      print("UserProfile is null");
      return;
    }
    try {
      await database.updateDocument(
          collectionId: dotenv.env['USER_COLLECTION_ID']!,
          databaseId: dotenv.env['USER_DATABASE_ID']!,
          documentId: userProfile!.username,
          data: {'biography': _titleController.text});
      print("Biography saved successfully");
      if (pixelUserData != null) {
        pixelUserData!.biography = _titleController.text;
        setState(() {});
      }
      _titleController.clear();
    } catch (e) {
      print("Error saving Biography: $e");
    }
  }

  Future<PixelUserClass?> fetchPixelUserInfo() async {
    try {
      final response = await database.getDocument(
          collectionId: dotenv.env['USER_COLLECTION_ID']!,
          documentId: userProfile!.username,
          databaseId: dotenv.env['USER_DATABASE_ID']!);
      return PixelUserClass.fromJson(response.data);
    } catch (e) {
      print('Error fetching document data: $e');
    }
    return null;
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

      setState(() {});
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
        bucketId: dotenv.env['USER_BUCKET_ID']!,
        fileId: fileName,
      );

      await storage.deleteFile(
        bucketId: dotenv.env['USER_BUCKET_ID']!,
        fileId: fileName,
      );
    } catch (e) {
      //Should probaly handle
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
      PageNavigator.navigateTo(const DummyDisplay());
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

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
                                        'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['USER_BUCKET_ID']}/files/${userProfile?.ntnuUsername ?? 'default'}/view?project=${dotenv.env['PROJECT_ID']}&mode=public',
                                        fit: BoxFit.cover,
                                        height: 240,
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
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
                                child: Text('Trykk for å laste opp profil bilde',
                                    style: OnlineTheme.textStyle(color: OnlineTheme.blue2)),
                              ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  style: OnlineTheme.textStyle(color: OnlineTheme.white),
                  decoration: InputDecoration(
                    labelText: 'Skriv om deg selv:',
                    labelStyle: OnlineTheme.textStyle(color: OnlineTheme.white),
                    hintStyle: OnlineTheme.textStyle(color: OnlineTheme.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: OnlineTheme.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: OnlineTheme.white),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    saveBiography();
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Biografi',
                  style: OnlineTheme.header(),
                ),
                FutureBuilder<PixelUserClass?>(
                  future: fetchPixelUserInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: SkeletonLoader(borderRadius: BorderRadius.circular(5)),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }
                    String biographyText = snapshot.data?.biography ?? '';
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        biographyText,
                        style: OnlineTheme.textStyle(weight: 5),
                      ),
                    );
                  },
                ),
                const Separator(margin: 40),
                Text(
                  'Kontakt',
                  style: OnlineTheme.header(),
                ),
                const SizedBox(height: 10),
                constValueTextInput('Brukernavn', userProfile!.ntnuUsername),
                constValueTextInput('Telefon', userProfile!.phoneNumber),
                constValueTextInput('E-post', userProfile!.email),
                const Separator(margin: 40),
                Text(
                  'Studie',
                  style: OnlineTheme.header(),
                ),
                const SizedBox(height: 10),
                constValueTextInput('Klassetrinn', userProfile!.year.toString()),
                constValueTextInput('Startår', userProfile!.startedDate.year.toString()),
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
                            style: OnlineTheme.subHeader(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            'Master',
                            style: OnlineTheme.subHeader(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'PhD',
                            style: OnlineTheme.subHeader(),
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
                    painter: StudyCoursePainter(year: userProfile!.year.toDouble()),
                  ),
                ),
                const Separator(margin: 40),
                AnimatedButton(
                  onTap: () {
                    loggedIn = false;
                    PageNavigator.navigateTo(const HomePage());
                  },
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: OnlineTheme.buttonHeight,
                      decoration: BoxDecoration(
                        color: OnlineTheme.red.withOpacity(0.4),
                        borderRadius: OnlineTheme.buttonRadius,
                        border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.red, width: 2)),
                      ),
                      child: Center(
                        child: Text(
                          'Logg Ut',
                          style: OnlineTheme.textStyle(weight: 5, color: OnlineTheme.red),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: Navbar.height(context) + 24),
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

  // Widget textInput(String label, String placeholder) {
  //   return SizedBox(
  //     height: 40,
  //     child: Row(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Expanded(
  //           child: Text(
  //             label,
  //             style: OnlineTheme.textStyle(color: OnlineTheme.gray11),
  //           ),
  //         ),
  //         Expanded(
  //           child: TextField(
  //             cursorColor: OnlineTheme.gray8,
  //             decoration: InputDecoration(
  //               hintText: placeholder,
  //               hintStyle: OnlineTheme.textStyle(
  //                 color: const Color(0xFF4C566A),
  //                 height: 1,
  //               ),
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(3),
  //                 borderSide: const BorderSide(color: Color(0xFF4C566A)),
  //               ),
  //               focusedBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.circular(3),
  //                 borderSide: const BorderSide(color: OnlineTheme.white),
  //               ),
  //               filled: true,
  //               fillColor: OnlineTheme.gray0,
  //             ),
  //             style: OnlineTheme.textStyle(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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

    line(year > 3, Offset(segment1, 0), Offset(segment1, size.height), canvas, paint);

    line(year >= 4, Offset(segment1 + 1.5, cy), c4, canvas, paint);
    line(year >= 5, c4, c5, canvas, paint);
    circle(year > 4, c4, canvas, paint);
    line(year > 5, c5, Offset(segment1 + segment2, cy), canvas, paint);
    circle(year >= 5, c5, canvas, paint);

    line(year > 5, Offset(segment1 + segment2, 0), Offset(segment1 + segment2, size.height), canvas, paint);

    line(year >= 6, Offset(segment1 + segment2 + 1.5, cy), c6, canvas, paint);
    circle(year >= 6, c6, canvas, paint);
  }

  void line(bool active, Offset start, Offset end, Canvas canvas, Paint paint) {
    final color = active ? green : gray;
    paint.color = color;
    canvas.drawLine(start, end, paint);
  }

  // static const gray = Color(0xFF153E75);
  static const gray = OnlineTheme.grayBorder;
  static const green = OnlineTheme.yellow;

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
