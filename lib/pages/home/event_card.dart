import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '/components/animated_button.dart';
import '/components/separator.dart';
import '/core/models/event_model.dart';
import '/pages/event/event_page.dart';
import '/services/page_navigator.dart';
import '/theme/theme.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.model,
  });

  final EventModel model;

  static const monthsNorwegian = {
    'January': 'Januar',
    'February': 'Februar',
    'March': 'Mars',
    'April': 'April',
    'May': 'Mai',
    'June': 'Juni',
    'July': 'Juli',
    'August': 'August',
    'September': 'September',
    'October': 'Oktober',
    'November': 'November',
    'December': 'Desember',
  };

  String formatDateSpan(String startDate, String endDate) {
    DateFormat inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    DateFormat outputDayFormat = DateFormat("dd");
    DateFormat outputMonthFormat = DateFormat("MMMM");

    DateTime startDateTime = inputFormat.parse(startDate, true).toLocal();
    DateTime endDateTime = inputFormat.parse(endDate, true).toLocal();

    String translateMonth(String month) {
      return monthsNorwegian[month] ??
          month; 
    }

    String startDay = outputDayFormat.format(startDateTime);
    String endDay = outputDayFormat.format(endDateTime);
    String startMonth = translateMonth(outputMonthFormat.format(startDateTime));
    String endMonth = translateMonth(outputMonthFormat.format(endDateTime));

    if (startDateTime.year == endDateTime.year &&
        startDateTime.month == endDateTime.month) {
      if (startDateTime.day == endDateTime.day) {
        return '$startDay. $startMonth';
      } else {
        return '$startDay.-$endDay. $startMonth';
      }
    } else {
      return '$startDay. $startMonth - $endDay. $endMonth';
    }
  }

  String shortenName() {
    final name = model.title;
    return name.replaceAll('Bedriftspresentasjon', 'Bedpres');
  }

  String registeredToString() {
    return '${model.numberOfSeatsTaken}/${model.maxCapacity}';
  }

  void showInfo() {
    PageNavigator.navigateTo(EventPageDisplay(
      model: model,
    ));
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
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
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
