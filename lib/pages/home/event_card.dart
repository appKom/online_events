import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:online/components/icon_label.dart';
import 'package:online/services/app_navigator.dart';
import 'package:online/theme/themed_icon.dart';

import '../../components/image_default.dart';
import '/components/animated_button.dart';
import '/components/separator.dart';
import '/components/skeleton_loader.dart';
import '/core/models/event_model.dart';
import '/pages/event/event_page.dart';
import '/theme/theme.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.model,
  });

  final EventModel model;

  static const monthsNorwegian = {
    'January': 'Jan',
    'February': 'Feb',
    'March': 'Mar',
    'April': 'Apr',
    'May': 'Mai',
    'June': 'Jun',
    'July': 'Jul',
    'August': 'Aug',
    'September': 'Sep',
    'October': 'Okt',
    'November': 'Nov',
    'December': 'Des',
  };

  String formatDateSpan(String startDate, String endDate) {
    DateFormat inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    DateFormat outputDayFormat = DateFormat("dd");
    DateFormat outputMonthFormat = DateFormat("MMMM");

    DateTime startDateTime = inputFormat.parse(startDate, true);
    DateTime endDateTime = inputFormat.parse(endDate, true);

    String translateMonth(String month) {
      return monthsNorwegian[month] ?? month;
    }

    String startDay = outputDayFormat.format(startDateTime);
    String endDay = outputDayFormat.format(endDateTime);
    String startMonth = translateMonth(outputMonthFormat.format(startDateTime));
    String endMonth = translateMonth(outputMonthFormat.format(endDateTime));

    if (startDateTime.year == endDateTime.year && startDateTime.month == endDateTime.month) {
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
    AppNavigator.navigateToPage(EventPageDisplay(
      model: model,
    ));
  }

  String participants() {
    if (model.maxCapacity == null) return '∞';

    return '${model.numberOfSeatsTaken}/${model.maxCapacity}';
  }

  static Widget skeleton() {
    return const SizedBox(
      height: 100,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 80,
                  child: SkeletonLoader(borderRadius: OnlineTheme.buttonRadius),
                ),
                SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SkeletonLoader(
                            width: 150,
                            height: 24,
                            borderRadius: OnlineTheme.buttonRadius,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SkeletonLoader(
                            borderRadius: OnlineTheme.buttonRadius,
                            width: 80,
                            height: 20,
                          ),
                          SkeletonLoader(
                            borderRadius: OnlineTheme.buttonRadius,
                            width: 50,
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bottom Separator
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Separator(),
          ),
        ],
      ),
    );
  }

  // static final gray = OnlineTheme.white;

  Widget defaultWithBorder() {
    return Container(
      decoration: const BoxDecoration(
          border: Border.fromBorderSide(
            BorderSide(width: 2, color: OnlineTheme.grayBorder),
          ),
          borderRadius: OnlineTheme.buttonRadius,
          color: OnlineTheme.background),
      child: const ImageDefault(),
    );
  }

  Widget eventIcon() {
    if (model.images.isEmpty) return defaultWithBorder();

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: OnlineTheme.white,
        child: CachedNetworkImage(
          imageUrl: model.images.first.md,
          fit: BoxFit.cover,
          placeholder: (context, url) => const SkeletonLoader(width: 100, height: 100),
          errorWidget: (context, url, error) => defaultWithBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Stack(
        children: [
          AnimatedButton(
            behavior: HitTestBehavior.opaque,
            onTap: showInfo,
            childBuilder: (context, hover, pointerDown) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox.square(
                      dimension: 80,
                      child: eventIcon(),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          header(),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconLabel(
                                icon: IconType.dateTime,
                                label: formatDateSpan(model.startDate, model.endDate),
                                color: OnlineTheme.lightGray,
                                fontWeight: 5,
                              ),
                              IconLabel(
                                icon: IconType.usersFilled,
                                label: participants(),
                                color: OnlineTheme.lightGray,
                                iconSize: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

  Widget header() {
    return Text(
      shortenName(),
      style: OnlineTheme.textStyle(
        color: OnlineTheme.white,
        weight: 6,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
