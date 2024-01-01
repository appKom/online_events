import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../components/animated_button.dart';
import '../pixel/view_pixel_user.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/components/separator.dart';
import '/core/client/client.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/attendees-list.dart';
import '/core/models/event_model.dart';
import '/core/models/waitlist.dart';
import '/pages/event/event_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

class ShowParticipants extends StaticPage {
  const ShowParticipants(
      {super.key, required this.model, required this.attendeeInfoModel});

  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 25);

    return LayoutBuilder(builder: (context, constraints) {
      final eventId = model.id;

      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Navbar.height(context) + 60),
            Row(
              children: [
                const SizedBox(
                  width: 80,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () => PageNavigator.navigateTo(EventPageDisplay(
                    model: model,
                  )),
                ),
                const SizedBox(
                  width: 25,
                ),
                Text(
                  'Påmeldte',
                  style: OnlineTheme.textStyle(size: 25, weight: 7),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Separator(
              margin: 5,
            ),
            FutureBuilder<List<AttendeesList>>(
              future: Client.getEventAttendees(eventId).then((attendees) {
                attendees.sort((a, b) {
                  if (a.isVisible && !b.isVisible) {
                    return -1;
                  } else if (!a.isVisible && b.isVisible) {
                    return 1;
                  }
                  return 0;
                });
                return attendees;
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: OnlineTheme.textStyle());
                } else if (snapshot.hasData) {
                  List<AttendeesList> sortedAttendees = snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedAttendees.length,
                    separatorBuilder: (context, index) =>
                        const Separator(), 
                    itemBuilder: (context, index) {
                      final attendee = sortedAttendees[index];
                      final bool isVerified =
                          attendee.fullName == "Mads Hermansen";

                      final String indexStr =
                          (index + 1).toString().padLeft(3, '0');
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: horizontalPadding,
                            child: Text('$indexStr. ',
                                style: OnlineTheme.textStyle(
                                    size: 16,
                                    color: isVerified
                                        ? Colors.green
                                        : Colors.white)),
                          ),
                          const SizedBox(width: 5,),
                          // AnimatedButton(onTap: () {
                          //   PageNavigator.navigateTo(ViewPixelUserDisplay(
                          //     userName: attendee.id.toString(),
                          //   ));
                          // }, childBuilder: (context, hover, pointerDown) {
                          //   return ClipOval(
                          //     child: SizedBox(
                          //       width: 30,
                          //       height: 30,
                          //       child: Image.network(
                          //         'https://cloud.appwrite.io/v1/storage/buckets/${dotenv.env['USER_BUCKET_ID']}/files/${attendee.id}/preview?width=75&height=75&project=${dotenv.env['PROJECT_ID']}&mode=public',
                          //         fit: BoxFit.cover,
                          //         height: 30,
                          //         errorBuilder:
                          //             (context, exception, stackTrace) {
                          //           return Image.asset(
                          //             'assets/images/default_profile_picture.png',
                          //             fit: BoxFit.cover,
                          //             height: 50,
                          //           );
                          //         },
                          //       ),
                          //     ),
                          //   );
                          // }),
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    attendee.fullName,
                                    style: OnlineTheme.textStyle(
                                        size: 16,
                                        color: isVerified
                                            ? Colors.green
                                            : Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isVerified)
                                  const SizedBox(
                                    width: 5,
                                  ),
                                if (isVerified)
                                  const Icon(Icons.check_circle_sharp,
                                      color: OnlineTheme.blue2, size: 16),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Row(
                              children: [
                                Text(
                                  '${attendee.yearOfStudy}. klasse',
                                  style: OnlineTheme.textStyle(
                                      size: 16,
                                      color: isVerified
                                          ? Colors.green
                                          : Colors.white),
                                  textAlign: TextAlign.right,
                                ),
                                IconButton(
                                  icon: Icon(Icons.people,
                                      color: isVerified
                                          ? Colors.green
                                          : Colors.white),
                                  onPressed: () {
                                    // Your onPressed functionality here
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Text('No attendees found',
                      style: OnlineTheme.textStyle());
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Separator(
              margin: 5,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 152,
                ),
                Text(
                  'Venteliste',
                  style: OnlineTheme.textStyle(size: 25, weight: 7),
                ),
              ],
            ),
            const Separator(
              margin: 5,
            ),
            FutureBuilder<List<Waitlist>>(
              future: Client.getEventWaitlists(eventId).then((attendees) {
                attendees.sort((a, b) {
                  if (a.isVisible && !b.isVisible) {
                    return -1;
                  } else if (!a.isVisible && b.isVisible) {
                    return 1;
                  }
                  return 0;
                });
                return attendees;
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: OnlineTheme.textStyle());
                } else if (snapshot.hasData) {
                  List<Waitlist> sortedAttendees = snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sortedAttendees.length,
                    separatorBuilder: (context, index) => const Separator(),
                    itemBuilder: (context, index) {
                      final attendee = sortedAttendees[index];
                      final bool isVerified =
                          attendee.fullName == "Mads Hermansen";
                      final String indexStr =
                          (index + 1).toString().padLeft(3, '0');
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: horizontalPadding,
                            child: Text('$indexStr. ',
                                style: OnlineTheme.textStyle(
                                    size: 16,
                                    color: isVerified
                                        ? Colors.green
                                        : Colors.white)),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    attendee.fullName,
                                    style: OnlineTheme.textStyle(
                                        size: 16,
                                        color: isVerified
                                            ? Colors.green
                                            : Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isVerified)
                                  const Icon(Icons.check_circle_sharp,
                                      color: OnlineTheme.blue2, size: 16),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Row(
                              children: [
                                Text(
                                  '${attendee.yearOfStudy}. klasse',
                                  style: OnlineTheme.textStyle(size: 16),
                                  textAlign: TextAlign.right,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.people,
                                      color: Colors.white),
                                  onPressed: () {
                                    // Your onPressed functionality here
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Text('No attendees found',
                      style: OnlineTheme.textStyle());
                }
              },
            ),
            SizedBox(height: Navbar.height(context) + 20),
          ],
        ),
      );
    });
  }
}
