import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_recaptcha/flutter_firebase_recaptcha.dart';
import 'package:http/http.dart' as http;

import '/components/image_default.dart';
import '/components/online_scaffold.dart';
import '/components/skeleton_loader.dart';
import '/core/client/client.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';
import '/core/models/event_organizers.dart';
import '/pages/event/cards/registration_card.dart';
import '/services/authenticator.dart';
import '/theme/theme.dart';
import 'cards/attendance_card.dart';
import 'cards/description_card.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

String recaptchaToken = '';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.model});
  final EventModel model;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  AttendeeInfoModel attendeeInfoModel;

  _EventPageState() : attendeeInfoModel = AttendeeInfoModel.withDefaults();

  late FirebaseRecaptchaVerifierModal recaptchaVerifier;

  @override
  void initState() {
    super.initState();
    refreshAttendance();
  }

  Future<void> refreshAttendance() async {
    AttendeeInfoModel? attendance = Authenticator.isLoggedIn()
        ? await Client.getEventAttendanceLoggedIn(widget.model.id)
        : await Client.getEventAttendance(widget.model.id);

    if (attendance != null) {
      setState(() {
        attendeeInfoModel = attendance;
      });
    }
  }

  void onUnregisterSuccess() {
    refreshAttendance();
  }

  void registerAttendance(String qrData) async {
    final parts = qrData.split(',');
    final rfid = parts[0];
    final username = parts[1];
    final event = int.tryParse(parts[2]) ?? 0;
    final approved = parts[3].toLowerCase() == 'true';

    const url = 'https://old.online.ntnu.no/api/v1/event/attendees/register-attendance/';

    final body = {
      'rfid': rfid,
      'username': username,
      'event': event,
      'approved': approved,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      print('Attendance registered successfully!');
    } else {
      print('Failed to register attendance. Status code: ${response.statusCode}');
    }
  }

  Widget coverImage() {
    if (widget.model.images.isEmpty) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(color: OnlineTheme.background, child: const ImageDefault()),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: OnlineTheme.white,
        child: CachedNetworkImage(
          imageUrl: widget.model.images.first.original,
          fit: BoxFit.cover,
          placeholder: (context, url) => const SkeletonLoader(),
          errorWidget: (context, url, error) => const ImageDefault(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(top: padding.top, bottom: padding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2, color: OnlineTheme.grayBorder),
              ),
            ),
            child: coverImage(),
          ),
          Padding(
            padding: OnlineTheme.horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  widget.model.title,
                  style: OnlineTheme.header(),
                ),
                const SizedBox(height: 24),
                AttendanceCard(event: widget.model, attendeeInfo: attendeeInfoModel),
                const SizedBox(height: 24),
                EventDescriptionCard(
                  description: widget.model.description,
                  ingress: widget.model.ingress,
                  organizer: eventOrganizers[widget.model.organizer] ?? '',
                ),
                const SizedBox(height: 24),
                RegistrationCard(
                  model: widget.model,
                  attendeeInfoModel: attendeeInfoModel,
                  onUnregisterSuccess: onUnregisterSuccess,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventPageDisplay extends ScrollablePage {
  const EventPageDisplay({super.key, required this.model});
  final EventModel model;

  @override
  Widget content(BuildContext context) {
    return EventPage(model: model);
  }
}
