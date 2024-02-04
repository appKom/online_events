import 'dart:core';

import 'package:flutter/material.dart';
import '/dark_overlay.dart';

import '/components/separator.dart';
import '/core/client/client.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/attendees_list.dart';
import '/core/models/event_model.dart';
import '/theme/theme.dart';

class ParticipantOverlay extends DarkOverlay {
  ParticipantOverlay({required this.model, required this.attendeeInfoModel});

  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;

  @override
  void show(BuildContext context) async {
    super.show(context);
    attendeesFuture = Client.getEventAttendees(model.id).then(sortAttendees);
    waitlistFuture = Client.getEventWaitlists(model.id).then(sortAttendees);
  }

  @override
  void hide() {
    attendeesFuture.ignore();
    waitlistFuture.ignore();
    super.hide();
  }

  late Future<List<AttendeesList>?> attendeesFuture;
  late Future<List<AttendeesList>?> waitlistFuture;

  @override
  Widget content(BuildContext context, Animation<double> animation) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildList('Påmeldte', attendeesFuture),
            buildList('Venteliste', waitlistFuture),
          ],
        ),
      ),
    );
  }

  List<AttendeesList> sortAttendees(List<AttendeesList>? input) {
    input ??= [];

    input.sort((a, b) {
      if (a.isVisible && !b.isVisible) {
        return -1;
      } else if (!a.isVisible && b.isVisible) {
        return 1;
      }
      return 0;
    });

    return input;
  }

  Widget buildList<T>(String header, Future<List<AttendeesList>?> listFuture) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 8),
          child: Text(
            header,
            style: OnlineTheme.header(),
            textAlign: TextAlign.center,
          ),
        ),
        const Separator(
          margin: 5,
        ),
        FutureBuilder(
          future: listFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}', style: OnlineTheme.textStyle());
            } else {
              final sortedAttendees = snapshot.data!;
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedAttendees.length,
                separatorBuilder: (context, index) => const Separator(),
                itemBuilder: (context, index) {
                  final attendee = sortedAttendees[index];
                  final bool isVerified = attendee.fullName == "Mads Hermansen";

                  final String indexStr = (index + 1).toString().padLeft(3, '0');
                  return SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            '$indexStr. ',
                            style: OnlineTheme.textStyle(
                              size: 16,
                              color: isVerified ? OnlineTheme.green : OnlineTheme.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  attendee.fullName,
                                  style:
                                      OnlineTheme.textStyle(size: 16, color: isVerified ? Colors.green : Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isVerified)
                                const SizedBox(
                                  width: 5,
                                ),
                              if (isVerified) const Icon(Icons.check_circle_sharp, color: OnlineTheme.blue2, size: 16),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Text(
                            '${attendee.yearOfStudy}. klasse',
                            style: OnlineTheme.textStyle(size: 16, color: isVerified ? Colors.green : Colors.white),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
