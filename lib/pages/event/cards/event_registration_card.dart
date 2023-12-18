import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/theme/theme.dart';

/// This appears to be the row with the width problems
class EventRegistrationCard extends StatelessWidget {
  const EventRegistrationCard(
      {super.key, required this.attendeeInfoModel});

  final AttendeeInfoModel attendeeInfoModel;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM, HH:mm');
    String formattedRegistrationStart = 'N/A';
    String formattedRegistrationEnd = '';
    String formattedUnattend = '';

    formattedRegistrationStart =
        dateFormat.format(attendeeInfoModel.registrationStart);
    formattedRegistrationEnd =
        dateFormat.format(attendeeInfoModel.registrationEnd);
    formattedUnattend = dateFormat.format(attendeeInfoModel.unattendDeadline);

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
              width: 95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Påmeldingsstart',
                    style: OnlineTheme.textStyle(
                        size: 12,
                        height: 1.5,
                        color: OnlineTheme.gray11,
                        weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  Center(
                    child: Text(
                      formattedRegistrationStart,
                      style: OnlineTheme.textStyle(
                          size: 14,
                          height: 1.5,
                          color: OnlineTheme.gray11,
                          weight: 4),
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
              width: 95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Påmeldingsslutt',
                    style: OnlineTheme.textStyle(
                        size: 12,
                        height: 1.5,
                        color: OnlineTheme.gray11,
                        weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  Center(
                    child: Text(
                      formattedRegistrationEnd,
                      style: OnlineTheme.textStyle(
                          size: 14,
                          height: 1.5,
                          color: OnlineTheme.gray11,
                          weight: 4),
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
              width: 95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avmeldingsfrist',
                    style: OnlineTheme.textStyle(
                        size: 12,
                        height: 1.5,
                        color: OnlineTheme.gray11,
                        weight: 4),
                    overflow: TextOverflow.visible,
                  ),
                  // Center text
                  Center(
                    child: Text(
                      formattedUnattend,
                      style: OnlineTheme.textStyle(
                          size: 14,
                          height: 1.5,
                          color: OnlineTheme.gray11,
                          weight: 4),
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
