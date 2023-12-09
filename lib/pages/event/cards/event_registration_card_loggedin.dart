// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/theme/theme.dart';

/// This appears to be the row with the width problems
class EventRegistrationCardLoggedIn extends StatelessWidget {
  const EventRegistrationCardLoggedIn(
      {super.key, required this.attendeeInfoModel});

  final AttendeeInfoModel attendeeInfoModel;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM, HH:mm');
    String formattedRegistrationStart = 'N/A';
    String formattedRegistrationEnd = '';
    String formattedUnattend = '';

    if (attendeeInfoModel.id != -1) {
      // Format the dates only if id is not -1
      formattedRegistrationStart = attendeeInfoModel.registrationStart != null
          ? dateFormat.format(attendeeInfoModel.registrationStart)
          : 'N/A';
      formattedRegistrationEnd = attendeeInfoModel.registrationEnd != null
          ? dateFormat.format(attendeeInfoModel.registrationEnd)
          : '';
      formattedUnattend = attendeeInfoModel.unattendDeadline != null
          ? dateFormat.format(attendeeInfoModel.unattendDeadline)
          : '';
    }
    if (attendeeInfoModel.isEligibleForSignup.statusCode != 502 &&
        attendeeInfoModel.isEligibleForSignup.statusCode != 411 &&
        attendeeInfoModel.isEligibleForSignup.statusCode != 6969 &&
        attendeeInfoModel.isEligibleForSignup.statusCode != 404) {
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
                width: 90,
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
                width: 90,
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
    } else {
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
}
