import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/separator.dart';
import 'package:online_events/core/models/attendee_info_model.dart';
import 'package:online_events/core/models/event_model.dart';
import 'package:online_events/pages/event/event_page.dart';
import '../../services/page_navigator.dart';
import '../../theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class EventCard extends StatelessWidget {
  const EventCard(
      {super.key,
      required this.model,});

  final EventModel model;

  static const months = [
    'Januar',
    'Februar',
    'Mars',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String formatDateSpan(String startDate, String endDate) {
    DateFormat inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    DateFormat outputDayMonthFormat = DateFormat("dd. MMMM");

    DateTime startDateTime = inputFormat.parse(startDate, true).toLocal();
    DateTime endDateTime = inputFormat.parse(endDate, true).toLocal();

    if (startDateTime.year == endDateTime.year &&
        startDateTime.month == endDateTime.month &&
        startDateTime.day == endDateTime.day) {
      // Same day
      return outputDayMonthFormat.format(startDateTime);
    } else {
      // Different days
      String formattedStartDate = outputDayMonthFormat.format(startDateTime);
      String formattedEndDate = outputDayMonthFormat.format(endDateTime);
      return "$formattedStartDate - $formattedEndDate";
    }
  }

  String shortenName() {
    final name = model.title;
    return name.replaceAll('Bedriftspresentasjon', 'Bedpress');
  }

  String registeredToString() {
    return '${model.numberOfSeatsTaken}/${model.maxCapacity}';
  }

  void showInfo() {
    PageNavigator.navigateTo(EventPageDisplay(model: model,));
  }

  String peopleToString() {
    if (model.maxCapacity == null) return 'Ubegrenset';

    return '${model.numberOfSeatsTaken}/${model.maxCapacity}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 111,
      child: Stack(
        children: [
          AnimatedButton(
            behavior: HitTestBehavior.opaque,
            onTap: showInfo,
            childBuilder: (context, hover, pointerDown) {
              return Stack(
                children: [
                  // Event Icon
                  Positioned(
                    left: 0,
                    top: 10,
                    width: 84,
                    height: 84,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: model.images.isNotEmpty
                          ? Image.network(
                              model.images.first.md,
                              fit: BoxFit.cover,
                            )
                          : SvgPicture.asset(
                              'assets/svg/online_hvit_o.svg', // Replace with your default image asset path
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  // Headers
                  Positioned(
                    left: 100,
                    top: 10,
                    right: 0,
                    height: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Name
                        SizedBox(
                          height: 24,
                          child: Text(
                            shortenName(),
                            style: OnlineTheme.textStyle(
                              color: OnlineTheme.gray11,
                              weight: 7,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subHeader(Icons.calendar_month_outlined,
                            formatDateSpan(model.startDate, model.endDate)),
                        subHeader(
                          Icons.people_outline,
                          peopleToString(),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 15,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'INFO',
                          style: OnlineTheme.textStyle(
                            color: OnlineTheme.gray9,
                            weight: 5,
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.navigate_next,
                            color: OnlineTheme.gray9,
                            size: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // Bottom Separator
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Separator(),
          ),
        ],
      ),
    );
  }

  Widget subHeader(IconData icon, String text) {
    return SizedBox(
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(
              icon,
              color: OnlineTheme.gray9,
              size: 14,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: OnlineTheme.textStyle(
              size: 14,
              weight: 5,
              color: OnlineTheme.gray9,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
