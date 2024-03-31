import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:online/core/models/event_model.dart';
import 'package:online/core/models/user_search_model.dart';
import 'package:online/pages/event/event_page.dart';
import 'package:online/pages/event/view_participant_skeleton.dart';
import 'package:online/pages/feed/calendar_skeleton.dart';
import '../../components/image_default.dart';
import '../../components/skeleton_loader.dart';
import '../../core/client/client.dart';
import '../../services/app_navigator.dart';
import '../login/login_page.dart';
import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/theme/theme.dart';

class ViewParticipant extends StatefulWidget {
  const ViewParticipant({super.key, required this.search, required this.model});

  final String search;
  final EventModel model;

  @override
  ViewParticipantState createState() => ViewParticipantState();
}

class ViewParticipantState extends State<ViewParticipant> {
  UserSearchModel? userData;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    userSearch(search: widget.search);
  }

  Future<void> userSearch({required String search}) async {
    final response = await Client.searchUserProfile(search: search);

    if (response != null) {
      setState(() {
        userData = response;
        loading = false;
      });
    }
  }

  Widget defaultWithBorder() {
    return Container(
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(width: 2, color: OnlineTheme.grayBorder),
        ),
        borderRadius: OnlineTheme.buttonRadius,
      ),
      child: const ImageDefault(),
    );
  }

  Widget profilePicture(UserSearchModel? user) {
    if (user == null) {
      return SkeletonLoader(
        height: 300,
        width: 300,
        borderRadius: BorderRadius.circular(75),
      );
    }

    return ClipOval(
      child: SizedBox(
        width: 300,
        height: 300,
        child: CachedNetworkImage(
          imageUrl:
              'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['USER_BUCKET_ID']}/files/${user.username}/view?project=${dotenv.env['PROJECT_ID']}&mode=public',
          fit: BoxFit.cover,
          height: 300,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/default_profile_picture.png',
            fit: BoxFit.cover,
            height: 300,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return participantSkeletonLoader(context);

    final padding =
        MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;
    return Padding(
      padding: padding,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${userData?.firstName} ${userData?.lastName}',
                style: OnlineTheme.textStyle(size: 28),
              ),
              const SizedBox(
                height: 16,
              ),
              AnimatedButton(
                  onTap: () {},
                  childBuilder: (context, hover, pointerDown) {
                    return profilePicture(userData);
                  }),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${userData?.year}. Klasse',
                style: OnlineTheme.textStyle(weight: 5, size: 18),
              ),
              const Separator(
                margin: 10,
              ),
              Text(
                userData?.bio ?? '',
                style: OnlineTheme.textStyle(),
              ),
            ],
          ),
          Positioned(
            top: padding.right,
            right: 0,
            child: AnimatedButton(onTap: () {
              AppNavigator.replaceWithPage(
                  EventPageDisplay(model: widget.model));
            }, childBuilder: (context, hover, pointerDown) {
              return const Icon(
                Icons.close_outlined,
                color: OnlineTheme.white,
                size: 32,
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ViewParticipantDisplay extends StaticPage {
  const ViewParticipantDisplay(
      {super.key, required this.search, required this.model});

  final String search;
  final EventModel model;

  @override
  Widget content(BuildContext context) {
    return ViewParticipant(
      search: search,
      model: model,
    );
  }
}
