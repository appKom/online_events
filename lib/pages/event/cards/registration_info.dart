import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/components/separator.dart';
import '/core/models/attendee_info_model.dart';
import '/theme/theme.dart';

class RegistrationInfo extends StatelessWidget {
  const RegistrationInfo({super.key, required this.attendeeInfoModel});

  final AttendeeInfoModel attendeeInfoModel;

  Widget col(String header, String date) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            header,
            style: OnlineTheme.textStyle(size: 14),
            overflow: TextOverflow.visible,
          ),
          Center(
            child: Text(
              date,
              style: OnlineTheme.textStyle(size: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM, HH:mm');

    final start =
        dateFormat.format(attendeeInfoModel.registrationStart.toLocal());
    final end = dateFormat.format(attendeeInfoModel.registrationEnd.toLocal());
    final unregister =
        dateFormat.format(attendeeInfoModel.unattendDeadline.toLocal());

    return Row(
      children: [
        col('Start', start),
        const Separator(axis: Axis.vertical, margin: 2, length: 40),
        col('Slutt', end),
        const Separator(axis: Axis.vertical, margin: 2, length: 40),
        col('Avmelding', unregister),
      ],
    );
  }
}
