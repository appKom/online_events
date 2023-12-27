import 'package:flutter/material.dart';
import 'package:online_events/pages/pixel/pixel_class.dart';
import 'package:online_events/theme/theme.dart';

import '../../components/animated_button.dart';
import '../../components/online_header.dart';
import '../../components/online_scaffold.dart';
import 'pixel.dart';

class ViewPixelUser extends StaticPage {
  const ViewPixelUser({super.key, required this.pixelUserClass});

  final PixelUserClass pixelUserClass;

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: OnlineHeader.height(context) + 50),
        Text(
          pixelUserClass.nameAfterLastComma,
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
              // width: 50,
              height: 300,
              child: Image.network(
                'https://cloud.appwrite.io/v1/storage/buckets/658996fac01c08570158/files/${pixelUserClass.nameBeforeComma}/view?project=65706141ead327e0436a&mode=public',
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
      ],
    );
  }
}
