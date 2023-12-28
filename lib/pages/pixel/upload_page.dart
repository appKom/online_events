import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/pages/pixel/pixel.dart';
import '../../components/navbar.dart';
import '../../components/online_header.dart';
import '../../components/online_scaffold.dart';
import '../../services/app_navigator.dart';
import '../../theme/theme.dart';
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

  @override
  void initState() {
    super.initState();
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('65706141ead327e0436a');
    storage = Storage(client);
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

    try {
      final file = await storage.createFile(
        bucketId: '6589b4e47f3c8840e723',
        fileId: ID.unique(),
        file: InputFile.fromPath(
          path: _selectedImage!.path,
          filename:
              '${userProfile!.ntnuUsername}, ${_titleController.text}, ${userProfile!.firstName} ${userProfile!.lastName}',
        ),
      );

      print("Image uploaded successfully: $file");
      setState(() {
        //hei
      });
      PageNavigator.navigateTo(const DummyDisplay2());
    } catch (e) {
      print("Error uploading image: $e");
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
                    labelStyle: OnlineTheme.textStyle(
                        color: OnlineTheme.white), 
                    hintStyle: OnlineTheme.textStyle(
                        color: OnlineTheme.white), 
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: OnlineTheme
                              .white), 
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: OnlineTheme
                              .white), 
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
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return const UploadPage();
  }
}
