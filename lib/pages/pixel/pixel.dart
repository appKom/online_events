import 'dart:io';
import 'dart:math';

import 'package:appwrite/models.dart' as io;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import '../../components/animated_button.dart';
import '../../components/online_scaffold.dart';
import '../../services/app_navigator.dart';
import '../../theme/theme.dart';
import 'custom_file.dart';
import 'dummy2.dart';

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


  Future<void> uploadImage() async {
    if (_imageFile == null) {
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
        file: InputFile.fromPath(path: _imageFile!.path, filename: ID.unique(),),
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

  Future<List<CustomFile>> getSortedImages() async {
    try {
      final response =
          await storage.listFiles(bucketId: '6589b4e47f3c8840e723');
      List<CustomFile> files = parseFiles(response);
      files.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return files;
    } catch (e) {
      print("Error retrieving images: $e");
      return [];
    }
  }

  List<CustomFile> parseFiles(io.FileList fileList) {
    return fileList.files.map((file) {
      // Assuming each file object has a method to convert it to a Map<String, dynamic>
      Map<String, dynamic> fileData = file.toMap();
      print(fileData);
      return CustomFile.fromJson(fileData);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 20),
          Flexible(
            // Changed from Expanded to Flexible
            child: FutureBuilder<List<CustomFile>>(
              future: getSortedImages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No images found');
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var file = snapshot.data![index];
                    return Image.network(file.url);
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
              onTap: () async {
                await pickImage(ImageSource.gallery);
                if (_imageFile != null) {
                  await uploadImage();
                }
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
