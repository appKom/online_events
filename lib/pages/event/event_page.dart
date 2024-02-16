import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase_recaptcha/flutter_firebase_recaptcha.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:online/components/skeleton_loader.dart';

import '/components/animated_button.dart';
import '/components/online_scaffold.dart';
import '/core/client/client.dart';
import '/core/models/attendee_info_model.dart';
import '/core/models/event_model.dart';
import '/core/models/event_organizers.dart';
import '/main.dart';
import '/pages/event/cards/registration_card.dart';
import '/pages/event/qr_code.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import 'cards/attendance_card.dart';
import 'cards/description_card.dart';
import 'qr_code_scanner.dart';

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
    AttendeeInfoModel? attendance = loggedIn
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
        child: SvgPicture.asset(
          'assets/svg/online_hvit_o.svg',
          fit: BoxFit.cover,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        widget.model.images.first.original,
        loadingBuilder: (context, child, evt) {
          if (evt == null) return child;

          return const SkeletonLoader();
        },
        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
          return SvgPicture.asset(
            'assets/svg/online_hvit_o.svg',
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(top: padding.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          coverImage(),
          Padding(
            padding: EdgeInsets.only(left: 25, right: 25, bottom: padding.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  widget.model.title,
                  style: OnlineTheme.header(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox.square(
                      dimension: 40,
                      child: Center(
                        child: AnimatedButton(
                          onTap: () {
                            AppNavigator.navigateToRoute(
                              QRCode(model: widget.model),
                              additive: true,
                            );
                          },
                          childBuilder: (context, hover, pointerDown) {
                            return const ThemedIcon(
                              icon: IconType.qr,
                              size: 24,
                              color: OnlineTheme.white,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox.square(
                      dimension: 40,
                      child: Center(
                        child: AnimatedButton(
                          onTap: () async {
                            final qrResult = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const QrCodeScannerDisplay()),
                            );
                            if (qrResult != null) {
                              registerAttendance(qrResult);
                            }
                          },
                          childBuilder: (context, hover, pointerDown) {
                            return const ThemedIcon(
                              icon: IconType.camScan,
                              size: 24,
                              color: OnlineTheme.white,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
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
              ],
            ),
          ),
          const SizedBox(height: 24),
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
