import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online/services/app_navigator.dart';

import '../view_pixel_user.dart';
import '/components/animated_button.dart';
import '/pages/pixel/models/user_post.dart';
import '/theme/theme.dart';

class WhoPostedCard extends StatelessWidget {
  const WhoPostedCard({
    super.key,
    required this.post,
    required this.nameBeforeComma,
    required this.nameAfterLastComma,
    required this.formatDate,
  });

  final UserPostModel post;
  final String nameBeforeComma;
  final String nameAfterLastComma;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        AnimatedButton(onTap: () {
          AppNavigator.navigateToPage(ViewPixelUserDisplay(
            userName: nameBeforeComma,
          ));
        }, childBuilder: (context, hover, pointerDown) {
          return ClipOval(
            child: SizedBox(
              width: 50,
              height: 50,
              child: Image.network(
                'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['USER_BUCKET_ID']}/files/${post.username}/view?project=${dotenv.env['PROJECT_ID']}&mode=public',
                fit: BoxFit.cover,
                height: 50,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
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
        AnimatedButton(onTap: () {
          AppNavigator.navigateToPage(ViewPixelUserDisplay(
            userName: nameBeforeComma,
          ));
        }, childBuilder: (context, hover, pointerDown) {
          return Text(
            nameAfterLastComma,
            style: OnlineTheme.textStyle(weight: 4),
          );
        }),
        const Spacer(),
        Text(
          formatDate(post.createdAt),
          style: OnlineTheme.textStyle(weight: 4),
        )
      ],
    );
  }
}
