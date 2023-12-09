// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:online_events/components/navbar.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/components/separator.dart';
import 'package:online_events/core/client/client.dart';
import 'package:online_events/core/models/attendees-list.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/core/models/waitlist.dart';
import 'package:online_events/pages/home/home_page.dart';
import 'package:online_events/services/app_navigator.dart';

import '/theme/theme.dart';

class ShowParticipants extends StaticPage {
  const ShowParticipants({super.key, required this.model});

  final EventModel model;

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
            Row(children: [
            const SizedBox(width: 80,),
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40,),
              onPressed: () => PageNavigator.navigateTo(const HomePage()),
            ),
            const SizedBox(width: 25,),
            Text(
              'Påmeldte',
              style: OnlineTheme.textStyle(size: 25, weight: 7),
            ),

            ],
            ),
            const SizedBox(height: 8),
            const Separator(margin: 5,),
            FutureBuilder<List<AttendeesList>>(
              future: Client.getEventAttendees(eventId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: OnlineTheme.textStyle());
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final attendee = snapshot.data![index];
                      final String indexStr =
                          (index + 1).toString().padLeft(3, '0');
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: horizontalPadding,
                            child: Text(
                              '$indexStr. ',
                              style: OnlineTheme.textStyle(size: 16),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              attendee.fullName,
                              style: OnlineTheme.textStyle(size: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: Text(
                              '${attendee.yearOfStudy}. klasse',
                              style: OnlineTheme.textStyle(size: 16),
                              textAlign: TextAlign.right,
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
            Row(children: [
              SizedBox(width: 152,),
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
              future: Client.getEventWaitlists(eventId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: OnlineTheme.textStyle());
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final attendee = snapshot.data![index];
                      final String indexStr =
                          (index + 1).toString().padLeft(3, '0');
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: horizontalPadding,
                            child: Text(
                              '$indexStr. ',
                              style: OnlineTheme.textStyle(size: 16),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              attendee.fullName,
                              style: OnlineTheme.textStyle(size: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: Text(
                              '${attendee.yearOfStudy}. klasse',
                              style: OnlineTheme.textStyle(size: 16),
                              textAlign: TextAlign.right,
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
