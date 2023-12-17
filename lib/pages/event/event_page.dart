import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/separator.dart';
import 'package:online_events/core/client/client.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/core/models/event_organizers.dart';
import 'package:online_events/pages/profile/profile_page.dart';

import '/components/animated_button.dart';
import '/components/navbar.dart';
import '/components/online_header.dart';
import '/components/online_scaffold.dart';
import '/main.dart';
import '/pages/event/qr_code.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';
import '/theme/themed_icon.dart';
import 'cards/attendance_card.dart';
import 'cards/event_card_buttons.dart';
import 'cards/event_description_card.dart';
import 'cards/event_participants.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.model});
//
  final EventModel model;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  AttendeeInfoModel attendeeInfoModel;

  _EventPageState()
      : attendeeInfoModel =
            DEFAULT_ATTENDEE_MODEL; // Initialize with default or placeholder

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  Future<void> fetchAttendance() async {
    AttendeeInfoModel? attendance =
        await Client.getEventAttendance(widget.model.id);
    if (attendance != null) {
      setState(() {
        attendeeInfoModel = attendance;
      });
    }
    // You can remove the else part if you're initializing with default value
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
          header(),
          const SizedBox(height: 16),
          EventParticipants(model: model, attendeeInfoModel: attendeeInfoModel),
          const SizedBox(height: 20),
          Column(
            children: [
              const Separator(margin: 1),
              Center(
                child: Text(
                  'Du må være logget inn for å se din status.',
                  style: OnlineTheme.textStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Card header
Widget header() {
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
      ],
    ),
  );
}

class EventPageDisplay extends StaticPage {
  const EventPageDisplay({super.key, required this.model});
  final EventModel model;

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    return EventPage(model: model);
  }
}
