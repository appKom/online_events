import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/pages/pixel/pixel.dart';
import '../../components/navbar.dart';
import '../../components/online_header.dart';
import '../../components/online_scaffold.dart';
import '../../services/app_navigator.dart';
import '../../theme/theme.dart';
import '../home/profile_button.dart';
import '../profile/profile_page.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  UploadPageState createState() => UploadPageState();
}

class UploadPageState extends State<UploadPage> {
  final TextEditingController titleController = TextEditingController();
  late Storage storage;
  final TextEditingController _titleController = TextEditingController();
  File? _selectedImage;
  late Databases database;

  @override
  void initState() {
    super.initState();
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('65706141ead327e0436a');
    storage = Storage(client);
    database = Databases(client);
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ],
        );

        setState(() {
          if (croppedFile != null) {
            _selectedImage = File(croppedFile.path);
            checkIfButtonShouldBeEnabled();
          }
        });
      }
    } catch (e) {
      // Handle exceptions related to image picker or cropper
      print('Error picking and cropping image: $e');
    }
  }

  Future<void> uploadImage() async {
    if (_selectedImage == null) {
      print("No image selected");
      return;
    }

    try {
      await storage.getFile(
        bucketId: '658996fac01c08570158',
        fileId: ID.unique(),
      );

      await storage.deleteFile(
        bucketId: '6589b4e47f3c8840e723',
        fileId: ID.unique(),
      );
    } catch (e) {
      //Should probaly handle
    }

    String imageIdBeNotPoppin =
        '${userProfile!.username}${formatDateTime(DateTime.now())}';

    try {
      final file = await storage.createFile(
        bucketId: '6589b4e47f3c8840e723',
        fileId: imageIdBeNotPoppin,
        file: InputFile.fromPath(
          path: _selectedImage!.path,
          filename: '${userProfile!.username}${formatDateTime(DateTime.now())}',
        ),
      );

      print("Image uploaded successfully: $file");
      setState(() {
        //hei
      });
      savePostToDataBase(imageIdBeNotPoppin);
      PageNavigator.navigateTo(const DummyDisplay2());
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  String formatDateTime(DateTime dateTime) {
    String formattedDate =
        '${dateTime.day}_${dateTime.month}_${dateTime.year}_${dateTime.second}';
    return formattedDate;
  }

  String formatDateTime2(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy.HH:mm:ss');
    return formatter.format(dateTime);
  }

  Future<void> savePostToDataBase(String imageIdbePoppin) async {
    String imageId = imageIdbePoppin;
    if (userProfile == null) {
      print("UserProfile is null");
      return;
    }

    try {
      await database.createDocument(
          collectionId: '658dfd035a1c33a77037',
          databaseId: '658df78529d1a989a672',
          documentId: ID.unique(),
          data: {
            'image_name': userProfile!.username,
            'number_of_likes': 0,
            'username': userProfile!.ntnuUsername,
            'first_name': userProfile!.firstName,
            'last_name': userProfile!.lastName,
            'description': _titleController.text,
            'post_created': formatDateTime2(DateTime.now()),
            'image_link':
                'https://cloud.appwrite.io/v1/storage/buckets/6589b4e47f3c8840e723/files/$imageId/view?project=65706141ead327e0436a&mode=public'
          });
      print("Post saved successfully");
    } catch (e) {
      print("Error posting post: $e");
    }
  }

  void checkIfButtonShouldBeEnabled() {
    if (_selectedImage != null && _titleController.text.isNotEmpty) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);
    return Scaffold(
      backgroundColor: OnlineTheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Flexible(
            child: Column(
              children: <Widget>[
                SizedBox(height: OnlineHeader.height(context) + 20),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () =>
                          PageNavigator.navigateTo(const PixelPageDisplay()),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    Center(
                      child: Text(
                        'Last opp et bilde',
                        style: OnlineTheme.textStyle(size: 25, weight: 5),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _titleController,
                  style: OnlineTheme.textStyle(color: OnlineTheme.white),
                  decoration: InputDecoration(
                    labelText: 'Beskrivelse',
                    labelStyle: OnlineTheme.textStyle(color: OnlineTheme.white),
                    hintStyle: OnlineTheme.textStyle(color: OnlineTheme.white),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: OnlineTheme.white),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: OnlineTheme.white),
                    ),
                  ),
                  onChanged: (_) => checkIfButtonShouldBeEnabled(),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_selectedImage != null) Image.file(_selectedImage!),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                  child: Row(children: [
                    Flexible(
                      child: AnimatedButton(
                          onTap: () => pickImage(ImageSource.gallery),
                          childBuilder: (context, hover, pointerDown) {
                            return Container(
                              height: 50,
                              decoration: const BoxDecoration(
                                gradient: OnlineTheme.purpleGradient,
                                borderRadius: OnlineTheme.eventButtonRadius,
                              ),
                              child: Center(
                                child: Text(
                                  'Velg bilde',
                                  style: OnlineTheme.textStyle(),
                                ),
                              ),
                            );
                          }),
                    ),
                    // const Spacer(),
                    const SizedBox(
                      width: 10,
                    ),
                    if (_selectedImage != null)
                      Flexible(
                        child: AnimatedButton(onTap: () {
                          if (_selectedImage != null) {
                            uploadImage();
                          }
                        }, childBuilder: (context, hover, pointerDown) {
                          return Container(
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: OnlineTheme.greenGradient,
                              borderRadius: OnlineTheme.eventButtonRadius,
                            ),
                            child: Center(
                              child: Text(
                                'Publiser',
                                style: OnlineTheme.textStyle(),
                              ),
                            ),
                          );
                        }),
                      ),
                  ]),
                ),
                SizedBox(height: Navbar.height(context) + 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UploadPageDisplay extends StaticPage {
  const UploadPageDisplay({super.key});
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
      buttons: const [
        ProfileButton(),
      ],
    );
  }

  @override
  Widget content(BuildContext context) {
    return const UploadPage();
  }
}
