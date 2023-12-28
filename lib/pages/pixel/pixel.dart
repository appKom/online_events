import 'dart:io';
import 'dart:math';

import 'package:appwrite/models.dart' as io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:intl/intl.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/main.dart';
import 'package:online_events/pages/pixel/view_pixel_user.dart';
import 'package:online_events/pages/profile/profile_page.dart';
import '../../components/animated_button.dart';
import '../../components/online_scaffold.dart';
import '../../components/separator.dart';
import '../../services/app_navigator.dart';
import '../../theme/theme.dart';
import '../login/auth_web_view_page.dart';
import 'custom_file.dart';
import 'pixel_class.dart';
import 'upload_page.dart';

class PixelPage extends StatefulWidget {
  const PixelPage({super.key});

  @override
  PixelPageState createState() => PixelPageState();
}

class PixelPageState extends State<PixelPage> {
  late Storage storage;
  File? _imageFile;

  //TODO Comments, like picture, show User Profile and chronological order

  @override
  void initState() {
    super.initState();
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('65706141ead327e0436a');
    storage = Storage(client);
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future<List<CustomFile>> getSortedImages() async {
    try {
      final response =
          await storage.listFiles(bucketId: '6589b4e47f3c8840e723');
      List<CustomFile> files = parseFiles(response);
      files.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return files;
    } catch (e) {
      print("Error retrieving images: $e");
      return [];
    }
  }

  List<CustomFile> parseFiles(io.FileList fileList) {
    return fileList.files.map((file) {
      Map<String, dynamic> fileData = file.toMap();
      return CustomFile.fromJson(fileData);
    }).toList();
  }

  String formatRelativeTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays >= 7) {
      return '${(difference.inDays / 7).floor()}w';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}t';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}min';
    } else {
      return '${difference.inSeconds}s';
    }
  }

  void deleteImage(String fileId) async {
    print(fileId);
    try {
      print(fileId);
      await storage.deleteFile(
          bucketId: '6589b4e47f3c8840e723', fileId: fileId);
      print('Bilde er slettet');
    } catch (e) {
      print("Error deleting image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);
    if (loggedIn) {
      return Scaffold(
        backgroundColor: OnlineTheme.background,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: OnlineHeader.height(context) + 20),
            Text(
              'Pixel',
              style: OnlineTheme.textStyle(size: 30, weight: 7)
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Flexible(
              child: FutureBuilder<List<CustomFile>>(
                future: getSortedImages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No images found');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var file = snapshot.data![index];
                      int firstCommaIndex = file.name.indexOf(',');
                      int lastCommaIndex = file.name.lastIndexOf(',');

                      String nameBeforeComma = firstCommaIndex != -1
                          ? file.name.substring(0, firstCommaIndex)
                          : file.name;
                      String description = (firstCommaIndex != -1 &&
                              lastCommaIndex != -1 &&
                              firstCommaIndex < lastCommaIndex)
                          ? file.name
                              .substring(firstCommaIndex + 1, lastCommaIndex)
                              .trim()
                          : (firstCommaIndex != -1
                              ? file.name.substring(firstCommaIndex + 1).trim()
                              : '');

                      String nameAfterLastComma = lastCommaIndex != -1 &&
                              file.name.length > lastCommaIndex + 1
                          ? file.name.substring(lastCommaIndex + 1).trim()
                          : '';

                      String formattedDate = formatRelativeTime(file.createdAt);

                      PixelUserClass fileNameDetails = PixelUserClass(
                          nameBeforeComma: nameBeforeComma,
                          nameAfterLastComma: nameAfterLastComma);

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                  color: OnlineTheme.background),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  AnimatedButton(onTap: () {
                                    PageNavigator.navigateTo(ViewPixelUser(
                                      pixelUserClass: fileNameDetails,
                                    ));
                                  }, childBuilder:
                                      (context, hover, pointerDown) {
                                    return ClipOval(
                                      child: SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: Image.network(
                                          'https://cloud.appwrite.io/v1/storage/buckets/658996fac01c08570158/files/$nameBeforeComma/view?project=65706141ead327e0436a&mode=public',
                                          fit: BoxFit.cover,
                                          height: 50,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Image.asset(
                                              'assets/images/default_profile_picture.png',
                                              fit: BoxFit.cover,
                                              height: 50,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    nameAfterLastComma,
                                    style: OnlineTheme.textStyle(weight: 4),
                                  ),
                                  const Spacer(),
                                  Text(
                                    formattedDate,
                                    style: OnlineTheme.textStyle(weight: 4),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Image.network(file.url),
                                AnimatedButton(
                                  childBuilder: (context, hover, pointerDown) {
                                    return Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        color: OnlineTheme.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 24,
                                        icon: const Icon(Icons.delete,
                                            color: OnlineTheme.background),
                                        onPressed: () async {
                                          try {
                                            deleteImage(file.id);
                                            print('Image deleted successfully');
                                            PageNavigator.navigateTo(const DummyDisplay2());
                                          } catch (e) {
                                            print("Error deleting image: $e");
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Container(
                              height: 20,
                              child: Text(
                                description,
                                style: OnlineTheme.textStyle(),
                              ),
                            ),
                            const Separator(margin: 20),
                          ]);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 20), // Add padding at the bottom for the button
              child: AnimatedButton(
                onTap: () {
                  PageNavigator.navigateTo(const UploadPageDisplay());
                },
                childBuilder: (context, hover, pointerDown) {
                  return Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      gradient: OnlineTheme.purpleGradient,
                      borderRadius: OnlineTheme.eventButtonRadius,
                    ),
                    child: Center(
                      child: Text(
                        'Last opp',
                        style: OnlineTheme.textStyle(),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: Navbar.height(context) + 10),
          ],
        ),
      );
    } else {
      void onPressed() {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const LoginWebView(),
        ));
      }

      return Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: OnlineHeader.height(context)),
              Center(
                child: Text(
                  'Du må være inlogget for å se Pixel',
                  style: OnlineTheme.textStyle(),
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              AnimatedButton(
                  onTap: onPressed,
                  childBuilder: (context, hover, pointerDown) {
                    return Container(
                      height: OnlineTheme.buttonHeight,
                      decoration: BoxDecoration(
                        gradient: OnlineTheme.greenGradient,
                        borderRadius: OnlineTheme.buttonRadius,
                      ),
                      child: Center(
                        child: Text(
                          'Logg Inn',
                          style: OnlineTheme.textStyle(weight: 5),
                        ),
                      ),
                    );
                  })
            ],
          ));
    }
  }
}

class PixelPageDisplay extends StaticPage {
  const PixelPageDisplay({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const PixelPage();
  }
}

class DummyDisplay2 extends StaticPage {
  const DummyDisplay2({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const PixelPage();
  }
}
