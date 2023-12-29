import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:online_events/pages/pixel/pixel_user_class.dart';
import 'package:online_events/theme/theme.dart';

import '../../components/animated_button.dart';
import '../../components/online_header.dart';
import '../../components/online_scaffold.dart';
import '../../components/separator.dart';
import 'pixel.dart';

class ViewPixelUser extends StatefulWidget {
  const ViewPixelUser({super.key, required this.userName});

  final String userName;
  

  @override
  ViewPixelUserState createState() => ViewPixelUserState();
}

class ViewPixelUserState extends State<ViewPixelUser> {
  late Databases database;
  PixelUserClass? userData;

  @override
  void initState() {
    super.initState();
    final client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('65706141ead327e0436a');
    database = Databases(client);

    fetchPixelUserInfo().then((userData) {
      if (userData != null) {
        setState(() {
          this.userData = userData;
        });
      }
    });
  }

  Future<PixelUserClass?> fetchPixelUserInfo() async {
    try {
      final response = await database.getDocument(
          collectionId: '658df9d98bf50c887791',
          documentId: widget.userName,
          databaseId: '658df9c7899c43cd556f');
      return PixelUserClass.fromJson(response.data);
    } catch (e) {
      print('Error fetching document data: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: OnlineHeader.height(context) + 50),
        Text(
          '${userData?.firstName} ${userData?.lastName}',
          style: OnlineTheme.textStyle(size: 32),
        ),
        const SizedBox(
          height: 16,
        ),
        AnimatedButton(onTap: () {
          //Eyo
        }, childBuilder: (context, hover, pointerDown) {
          return ClipOval(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Image.network(
                'https://cloud.appwrite.io/v1/storage/buckets/658996fac01c08570158/files/${widget.userName}/view?project=65706141ead327e0436a&mode=public',
                fit: BoxFit.cover,
                height: 300,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset(
                    'assets/images/default_profile_picture.png',
                    fit: BoxFit.cover,
                    height: 300,
                  );
                },
              ),
            ),
          );
        }),
        const SizedBox(height: 10,),
        Text('${userData?.year}. Klasse', style: OnlineTheme.textStyle(weight: 5, size: 18),),
        const Separator(margin: 10,),
        Text(userData?.biography ?? '', style: OnlineTheme.textStyle(),),
      ],
    );
  }
}

class ViewPixelUserDisplay extends StaticPage {
  const ViewPixelUserDisplay({super.key, required this.userName});

  final String userName;

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return ViewPixelUser(
      userName: userName,
    );
  }
}
