import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/core/client/client.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/core/models/event_organizers.dart';
import 'package:online_events/pages/event/cards/event_card_countdown.dart';
import 'package:online_events/pages/event/cards/event_participants.dart';
import 'package:online_events/pages/event/cards/event_registration_card.dart';
import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/main.dart';
import '/pages/event/qr_code.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import 'cards/card_badge.dart';
import 'cards/attendance_card.dart';
import 'cards/event_card_buttons.dart';
import 'cards/event_description_card.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.model});
//
  final EventModel model;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  AttendeeInfoModel attendeeInfoModel;

  _EventPageState() : attendeeInfoModel = DEFAULT_ATTENDEE_MODEL;

  @override
  void initState() {
    super.initState();
    if (loggedIn) {
      fetchAttendanceLoggedIn();
    }
    if (loggedIn == false){
      fetchAttendanceNotLoggedIn();
    }
  }

  Future<void> fetchAttendanceLoggedIn() async {
    AttendeeInfoModel? attendance =
        await Client.getEventAttendanceLoggedIn(widget.model.id);
    if (attendance != null) {
      setState(() {
        attendeeInfoModel = attendance;
      });
    }
  }

  Future<void> fetchAttendanceNotLoggedIn() async {
    AttendeeInfoModel? attendance =
        await Client.getEventAttendance(widget.model.id);
    if (attendance != null) {
      setState(() {
        attendeeInfoModel = attendance;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 24);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: OnlineHeader.height(context)),
          SizedBox(
            height: 230,
            child: widget.model.images.isNotEmpty
                ? Image.network(
                    widget.model.images.first.original,
                    fit: BoxFit.cover,
                  )
                : SvgPicture.asset(
                    'assets/svg/online_hvit_o.svg', // Replace with your default image asset path
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  widget.model.title,
                  style: OnlineTheme.textStyle(size: 20, weight: 7),
                ),
                const SizedBox(height: 24),
                AttendanceCard(
                  model: widget.model,
                ),
                const SizedBox(height: 24),
                EventDescriptionCard(
                  description: widget.model.description,
                  organizer: eventOrganizers[widget.model.organizer] ?? '',
                ),
                const SizedBox(height: 24),
                RegistrationCard(
                  model: widget.model,
                  attendeeInfoModel: attendeeInfoModel,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          SizedBox(
            height: Navbar.height(context) + 24,
          ),
        ],
      ),
    );
  }
}

/// Påmelding
class RegistrationCard extends StatelessWidget {
  static const horizontalPadding = EdgeInsets.symmetric(horizontal: 24);

  const RegistrationCard(
      {super.key, required this.model, required this.attendeeInfoModel});
  final EventModel model;
  final AttendeeInfoModel attendeeInfoModel;

  @override
  Widget build(BuildContext context) {
    final eventDateTime = DateTime.parse(model.startDate);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: OnlineTheme.background.lighten(20),
        border: Border.all(color: OnlineTheme.gray10.darken(80), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (loggedIn || attendeeInfoModel.isEligibleForSignup.statusCode == 6969)
          header(attendeeInfoModel.isEligibleForSignup.statusCode),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            const SizedBox(height: 16),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            EventParticipants(
              model: model,
              attendeeInfoModel: attendeeInfoModel,
            ),
          const SizedBox(height: 16),
          if (attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
            EventRegistrationCard(
              attendeeInfoModel: attendeeInfoModel,
            ),
          const SizedBox(height: 10),
          if ((loggedIn == true && attendeeInfoModel.isEligibleForSignup.status == false) || (loggedIn == false && attendeeInfoModel.isEligibleForSignup.statusCode == 6969))
            Center(
              child: Text(
                attendeeInfoModel.isEligibleForSignup.message,
                style: OnlineTheme.textStyle(),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
            EventCardButtons(
              model: model,
              attendeeInfoModel: attendeeInfoModel,
            ),
            if (loggedIn && attendeeInfoModel.isEligibleForSignup.statusCode != 6969)
          const SizedBox(
            height: 16,
          ),
          if (attendeeInfoModel.isEligibleForSignup.statusCode == 501)
            EventCardCountdown(eventTime: eventDateTime),
          if (attendeeInfoModel.isEligibleForSignup.statusCode == 501)
            Center(
                child: Text(
              'Til til arrangementet starter',
              style: OnlineTheme.textStyle(weight: 5),
            )),
          if (attendeeInfoModel.id == -1 &&
              eventDateTime.isAfter(DateTime.now()))
            EventCardCountdown(eventTime: eventDateTime),
          if (attendeeInfoModel.id == -1 &&
              eventDateTime.isAfter(DateTime.now()))
            const SizedBox(
              height: 10,
            ),
          if (attendeeInfoModel.id == -1 &&
              eventDateTime.isAfter(DateTime.now()))
            Center(
                child: Text(
              'Til til arrangementet starter',
              style: OnlineTheme.textStyle(weight: 5),
            )),
        ],
      ),
    );
  }
}

Widget header(int statusCode) {
  String badgeText;
  LinearGradient gradient;

  switch (statusCode) {
    case 502:
      badgeText = 'Closed';
      gradient = OnlineTheme.redGradient;
      break;

    case 502:
      badgeText = 'Stengt';
      gradient = OnlineTheme.redGradient;
      break;
    case 404:
      badgeText = 'Påmeldt';
      gradient = OnlineTheme.greenGradient;
      break;
    case 200 || 201 || 210 || 211 || 212 || 213:
      badgeText = 'Åpen';
      gradient = OnlineTheme.greenGradient;
      break;
    case 420 || 421 || 422 || 423 || 401 || 402:
      badgeText = 'Utsatt';
      gradient = OnlineTheme.blueGradient;
      break;
    case 411 || 410 || 412 || 413 || 400 || 400 || 403 || 405:
      badgeText = 'Umulig';
      gradient = OnlineTheme.blueGradient;
      break;
    default:
      badgeText = 'Ikke åpen';
      gradient = OnlineTheme.purpleGradient;
  }

  return SizedBox(
    height: 32,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Påmelding',
          style: OnlineTheme.eventHeader
              .copyWith(height: 1, fontWeight: FontWeight.w600),
        ),
        CardBadge(
          border: gradient.colors.last.lighten(100),
          gradient: gradient,
          text: badgeText,
        ),
      ],
    ),
  );
}

class EventPageDisplay extends StaticPage {
  const EventPageDisplay({super.key, required this.model});
  final EventModel model;

  @override
  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
      buttons: [
        if (loggedIn)
          SizedBox.square(
            dimension: 40,
            child: Center(
              child: AnimatedButton(
                onTap: () {
                  print('📸');
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
                    QRCode(name: 'Fredrik Hansteen'),
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

  @override
  Widget content(BuildContext context) {
    return EventPage(model: model);
  }
}
