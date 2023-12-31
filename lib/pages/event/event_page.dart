import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/core/client/client.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/core/models/event_organizers.dart';
import 'package:online_events/pages/event/cards/registration_card.dart';
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
import 'cards/event_description_card.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.model});
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
    return Scaffold(
    key: scaffoldKey,
    backgroundColor: OnlineTheme.background,
    body:RefreshIndicator(
      onRefresh: refreshAttendance,
      child: ListView(
        children: [
          SizedBox(height: OnlineHeader.height(context)-8),
          widget.model.images.isNotEmpty
              ? Image.network(
                  widget.model.images.first.original,
                  fit: BoxFit.cover,
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
                )
              : SvgPicture.asset(
                  'assets/svg/online_hvit_o.svg',
                  fit: BoxFit.cover,
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  widget.model.title,
                  style: OnlineTheme.textStyle(size: 20, weight: 7),
                ),
                const SizedBox(height: 24),
                AttendanceCard(model: widget.model),
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
                const SizedBox(height: 24),
              ],
            ),
          ),
          SizedBox(height: Navbar.height(context) + 24),
        ],
      ),
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
