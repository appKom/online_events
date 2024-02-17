import 'dart:core';

import 'package:flutter/material.dart';
import 'package:online/theme/themed_icon.dart';
import '/dark_overlay.dart';

import '/components/separator.dart';
import '/core/client/client.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/attendees_list.dart';
import '/core/models/event_model.dart';
import '/theme/theme.dart';

enum Role {
  none,
  verified,
}

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
      padding: const EdgeInsets.symmetric(horizontal: 50),
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

  Role getRole(AttendeesList attendee) {
    final name = attendee.fullName;

    if (name == 'Mads Hermansen') return Role.verified;

    return Role.none;
  }

  Color getColor(Role role) {
    switch (role) {
      case Role.none:
        return OnlineTheme.white;
      case Role.verified:
        return OnlineTheme.blue2;
    }
  }

  int getWeight(Role role) {
    return role == Role.none ? 4 : 5;
  }

  Widget indexLabel(int index, Color color) {
    final indexStr = (index + 1).toString();

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 35,
        child: Text(
          indexStr,
          style: OnlineTheme.textStyle(
            color: color,
            weight: 7,
            size: 15,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget progressIndicator() {
    return const Center(
      child: SizedBox.square(
        dimension: 25,
        child: CircularProgressIndicator(
          color: OnlineTheme.white,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget buildList<T>(String header, Future<List<AttendeesList>?> listFuture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            header,
            style: OnlineTheme.header(),
            textAlign: TextAlign.center,
          ),
        ),
        FutureBuilder(
          future: listFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return progressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}', style: OnlineTheme.textStyle());
            } else {
              final sortedAttendees = snapshot.data!;

              if (sortedAttendees.isEmpty) {
                return Text(
                  'Ingen',
                  style: OnlineTheme.textStyle(size: 15),
                  textAlign: TextAlign.center,
                );
              }

              return ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedAttendees.length,
                separatorBuilder: (context, index) => const Separator(),
                itemBuilder: (context, index) {
                  final attendee = sortedAttendees[index];

                  final role = getRole(attendee);
                  final color = getColor(role);
                  final weight = getWeight(role);

                  return SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        indexLabel(index, color),
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  attendee.fullName,
                                  style: OnlineTheme.textStyle(
                                    color: color,
                                    weight: weight,
                                    size: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (role == Role.verified) const SizedBox(width: 5),
                              if (role == Role.verified) ThemedIcon(icon: IconType.badgeCheck, color: color, size: 16),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          child: Text(
                            '${attendee.yearOfStudy}. klasse', // Takes less space than 'klasse'
                            style: OnlineTheme.textStyle(
                              color: color,
                              weight: weight,
                              size: 15,
                            ),
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
