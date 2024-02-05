import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
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
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(top: padding.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SizedBox(height: OnlineHeader.height(context)),
          widget.model.images.isNotEmpty
              ? AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    widget.model.images.first.original,
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
                      return SvgPicture.asset(
                        'assets/svg/online_hvit_o.svg',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                )
              : SvgPicture.asset(
                  'assets/svg/online_hvit_o.svg',
                  fit: BoxFit.cover,
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  widget.model.title,
                  style: OnlineTheme.header(),
                ),
                const SizedBox(height: 24),
                AttendanceCard(
                    event: widget.model, attendeeInfo: attendeeInfoModel),
                const SizedBox(height: 24),
                EventDescriptionCard(
                  description: widget.model.description,
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
          SizedBox(height: Navbar.height(context) + 24),
        ],
      ),
    );
  }
}

class EventPageDisplay extends ScrollablePage {
  const EventPageDisplay({super.key, required this.model});
  final EventModel model;

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
      buttons: [
        if (loggedIn)
          SizedBox.square(
            dimension: 40,
            child: Center(
              child: AnimatedButton(
                onTap: () async {
                  final qrResult = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QrCodeScannerDisplay()),
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
        if (loggedIn)
          SizedBox.square(
            dimension: 40,
            child: Center(
              child: AnimatedButton(
                onTap: () {
                  AppNavigator.navigateToRoute(
                    QRCode(model: model),
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
      ],
    );
  }

  void registerAttendance(String qrData) async {
    final parts = qrData.split(',');
    final rfid = parts[0];
    final username = parts[1];
    final event = int.tryParse(parts[2]) ?? 0;
    final approved = parts[3].toLowerCase() == 'true';

    const url =
        'https://old.online.ntnu.no/api/v1/event/attendees/register-attendance/';

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
      print(
          'Failed to register attendance. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget content(BuildContext context) {
    return EventPage(model: model);
  }
}
