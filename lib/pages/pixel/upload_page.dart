import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart' as io;
import '/pages/pixel/pixel.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

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
    final client = Client().setEndpoint('https://cloud.appwrite.io/v1').setProject(dotenv.env['PROJECT_ID']);
    storage = Storage(client);
    database = Databases(client);
  }

  Future<void> pickImage(ImageSource source) async {
    // TODO: Re-implement image upload with new version of image cropper

    // try {
    //   final ImagePicker picker = ImagePicker();
    //   final XFile? pickedFile = await picker.pickImage(source: source);

    //   if (pickedFile != null) {
    //     CroppedFile? croppedFile = await ImageCropper().cropImage(
    //       sourcePath: pickedFile.path,

    //       aspectRatioPresets: [
    //         CropAspectRatioPreset.square,
    //         CropAspectRatioPreset.ratio3x2,
    //         CropAspectRatioPreset.original,
    //         CropAspectRatioPreset.ratio4x3,
    //         CropAspectRatioPreset.ratio16x9
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
    //         _selectedImage = File(croppedFile.path);
    //         checkIfButtonShouldBeEnabled();
    //       }
    //     });
    //   }
    // } catch (e) {
    //   // Handle exceptions related to image picker or cropper
    //   print('Error picking and cropping image: $e');
    // }
  }

  Future<void> uploadImage() async {
    final user = io.Client.userCache.value;

    if (_selectedImage == null) {
      print("No image selected");
      return;
    }

    try {
      await storage.getFile(
        bucketId: dotenv.env['PIXEL_BUCKET_ID']!,
        fileId: ID.unique(),
      );

      await storage.deleteFile(
        bucketId: dotenv.env['PIXEL_BUCKET_ID']!,
        fileId: ID.unique(),
      );
    } catch (e) {
      //Should probaly handle
    }

    String imageIdBeNotPoppin = '${user!.username}${formatDateTime(DateTime.now())}';

    try {
      final file = await storage.createFile(
        bucketId: dotenv.env['PIXEL_BUCKET_ID']!,
        fileId: imageIdBeNotPoppin,
        file: InputFile.fromPath(
          path: _selectedImage!.path,
          filename: '${user.username}${formatDateTime(DateTime.now())}',
        ),
      );

      print("Image uploaded successfully: $file");
      setState(() {
        //hei
      });
      savePostToDataBase(imageIdBeNotPoppin);
      AppNavigator.navigateToPage(const DummyDisplay2());
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  String formatDateTime(DateTime dateTime) {
    String formattedDate = '${dateTime.day}_${dateTime.month}_${dateTime.year}_${dateTime.second}';
    return formattedDate;
  }

  String formatDateTime2(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy.HH:mm:ss');
    return formatter.format(dateTime);
  }

  Future<void> savePostToDataBase(String imageIdbePoppin) async {
    final user = io.Client.userCache.value;

    if (user == null) return;

    String imageId = imageIdbePoppin;

    try {
      await database.createDocument(
          collectionId: dotenv.env['PIXEL_COLLECTION_ID']!,
          databaseId: dotenv.env['PIXEL_DATABASE_ID']!,
          documentId: ID.unique(),
          data: {
            'image_name': user.username,
            'number_of_likes': 0,
            'username': user.ntnuUsername,
            'first_name': user.firstName,
            'last_name': user.lastName,
            'description': _titleController.text,
            'post_created': formatDateTime2(DateTime.now()),
            'image_link':
                'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['PIXEL_BUCKET_ID']}/files/$imageId/view?project=${dotenv.env['PROJECT_ID']}&mode=public'
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
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    final theme = OnlineTheme.current;

    return Scaffold(
      backgroundColor: OnlineTheme.current.bg,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: padding.left, right: padding.right),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () => AppNavigator.navigateToPage(const PixelPageDisplay()),
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
                style: OnlineTheme.textStyle(color: theme.fg),
                decoration: InputDecoration(
                  labelText: 'Beskrivelse',
                  labelStyle: OnlineTheme.textStyle(color: theme.fg),
                  hintStyle: OnlineTheme.textStyle(color: theme.fg),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.fg),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: theme.fg),
                  ),
                ),
                maxLength: 500,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                onChanged: (_) => checkIfButtonShouldBeEnabled(),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_selectedImage != null) Image.file(_selectedImage!),
              if (_selectedImage != null)
                const SizedBox(
                  height: 10,
                ),
              if (_selectedImage != null)
                Column(
                  children: [
                    Text(
                      _titleController.text,
                      style: OnlineTheme.textStyle(),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                child: Row(children: [
                  Flexible(
                    child: AnimatedButton(
                        onTap: () => pickImage(ImageSource.gallery),
                        childBuilder: (context, hover, pointerDown) {
                          return Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              gradient: OnlineTheme.purpleGradient,
                              borderRadius: OnlineTheme.buttonRadius,
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
                            borderRadius: OnlineTheme.buttonRadius,
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
    );
  }
}

class UploadPageDisplay extends StaticPage {
  const UploadPageDisplay({super.key});

  @override
  Widget content(BuildContext context) {
    return const UploadPage();
  }
}
