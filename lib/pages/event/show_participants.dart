import 'dart:math';

import 'package:flutter/material.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/components/separator.dart';
import 'package:online_events/core/client/client.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/attendees-list.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/core/models/waitlist.dart';
import 'package:online_events/pages/event/event_page_loggedin.dart';
import 'package:online_events/services/app_navigator.dart';

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
      final maxSize = min(constraints.maxWidth, constraints.maxHeight);
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
                  onPressed: () => PageNavigator.navigateTo(EventPageLoggedIn(
                      model: model, attendeeInfoModel: attendeeInfoModel)),
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
                if (attendees != null) {
                  attendees.sort((a, b) {
                    if (a.isVisible && !b.isVisible) {
                      return -1;
                    } else if (!a.isVisible && b.isVisible) {
                      return 1;
                    }
                    return 0;
                  });
                }
                return attendees ?? [];
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
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: sortedAttendees.length,
                    separatorBuilder: (context, index) =>
                        const Separator(), // Thinner divider
                    itemBuilder: (context, index) {
                      final attendee = sortedAttendees[index];
                      final bool isVerified =
                          attendee.fullName == "Fredrik Carsten Hansteen" ||
                              attendee.fullName == "Erlend Løvoll Strøm";
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
                if (attendees != null) {
                  attendees.sort((a, b) {
                    if (a.isVisible && !b.isVisible) {
                      return -1;
                    } else if (!a.isVisible && b.isVisible) {
                      return 1;
                    }
                    return 0;
                  });
                }
                return attendees ?? [];
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
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: sortedAttendees.length,
                    separatorBuilder: (context, index) => const Separator(),
                    itemBuilder: (context, index) {
                      final attendee = sortedAttendees[index];
                      final bool isVerified =
                          attendee.fullName == "Fredrik Carsten Hansteen" ||
                              attendee.fullName == "Erlend Løvoll Strøm";
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
