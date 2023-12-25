import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';

import '../../components/animated_button.dart';
import '../../components/online_scaffold.dart';
import '../../theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_sdk/cloudinary_sdk.dart';

class PixelPage extends StatefulWidget {
  const PixelPage({super.key});

  @override
  PixelPageState createState() => PixelPageState();
}

class PixelPageState extends State<PixelPage> {
  File? _imageFile;
  String? _imageUrl;

  final Cloudinary cloudinary = Cloudinary.basic(
    cloudName: 'dgha3rudz',
  );

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: source); // corrected variable name here
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path); // consistent variable name
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;
    try {
      String fileName = 'test1';
      final response = await cloudinary.unsignedUploadResource(
        CloudinaryUploadResource(
          filePath: _imageFile!.path,
          resourceType: CloudinaryResourceType.image,
          uploadPreset: 'zcaifeop', // Set your upload preset here
          fileName: fileName,
        ),
      );
      if (response.isSuccessful) {
        print('suksee');
        setState(() {
          _imageUrl = response.secureUrl;
        });
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  List<String> imageUrls = [
    'https://res.cloudinary.com/dgha3rudz/image/upload/v1703415759/public/ahryfjzxgcgwoncx2hjm.jpg',
    // add more URLs here
  ];

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: OnlineHeader.height(context) + 20),
          Text(
            'Pixel',
            style: OnlineTheme.textStyle(size: 30, weight: 7),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: 50,
            child: AnimatedButton(
              onTap: () async {
                await _pickImage(ImageSource.gallery);
                if (_imageFile != null) {
                  await _uploadImage();
                }
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  height: OnlineTheme.buttonHeight,
                  decoration: const BoxDecoration(
                    gradient: OnlineTheme.purpleGradient,
                    borderRadius: OnlineTheme.buttonRadius,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Last opp',
                          style: OnlineTheme.textStyle(weight: 5),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          if (_imageFile != null)
            Container(
              height: 150,
              child: Image.file(_imageFile!),
            ),
          Column(
            children: [
              for (var imageUrl in imageUrls) Image.network(imageUrl),
            ],
          ),
          SizedBox(height: Navbar.height(context)),
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
