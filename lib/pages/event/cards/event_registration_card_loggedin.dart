import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/theme/theme.dart';

/// This appears to be the row with the width problems
class EventRegistrationCardLoggedIn extends StatelessWidget {
  const EventRegistrationCardLoggedIn ({super.key, required this.attendeeInfoModel});
  
  final AttendeeInfoModel attendeeInfoModel;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM, HH:mm');

    // Format the registrationStart DateTime using the dateFormat
    final formattedRegistrationStart = dateFormat.format(attendeeInfoModel.registrationStart);
    final formattedRegistrationEnd = dateFormat.format(attendeeInfoModel.registrationEnd);
    final formattedunattend = dateFormat.format(attendeeInfoModel.unattendDeadline);
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Påmeldingsstart',
                    style: OnlineTheme.textStyle(size: 12, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  Center(
                    child: Text(
                      formattedRegistrationStart,
                      style: OnlineTheme.textStyle(size: 14, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: OnlineTheme.gray8,
              margin: const EdgeInsets.symmetric(horizontal: 5),
            ),
            SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Påmeldingsslutt',
                    style: OnlineTheme.textStyle(size: 12, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  Center(
                    child: Text(
                      formattedRegistrationEnd,
                      style: OnlineTheme.textStyle(size: 14, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 20,
              color: OnlineTheme.gray8,
              margin: const EdgeInsets.symmetric(horizontal: 5),
            ),
            SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avmeldingsfrist',
                    style: OnlineTheme.textStyle(size: 12, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  // Center text
                  Center(
                    child: Text(
                      formattedunattend,
                      style: OnlineTheme.textStyle(size: 14, height: 1.5, color: OnlineTheme.gray11, weight: 4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
