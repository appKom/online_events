import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online/components/icon_label.dart';
import 'package:online/services/app_navigator.dart';

import '../../theme/themed_icon.dart';
import '/components/animated_button.dart';
import '/components/skeleton_loader.dart';
import '/core/models/event_model.dart';
import '/pages/event/event_page.dart';
import '/theme/theme.dart';

class Bedpress extends StatelessWidget {
  const Bedpress({
    super.key,
    required this.models,
  });

  final Set<EventModel> models;

  static Widget skeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Bedriftpresentasjoner og Kurs',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
        ),
        SizedBox(
          height: 236,
          child: ListView.builder(
            itemCount: 2,
            itemBuilder: (c, i) {
              return Padding(
                padding: const EdgeInsets.only(right: 24),
                child: SkeletonLoader(
                  borderRadius: BorderRadius.circular(12),
                  width: 222,
                ),
              );
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final futureEvents = models.where((event) {
      final eventDate = DateTime.parse(event.endDate);
      return eventDate.isAfter(DateTime.now());
    }).toList();

    final filteredModels = futureEvents.where((model) => model.eventType == 2 || model.eventType == 3).toList();

    final options = CarouselOptions(
      height: 320,
      enableInfiniteScroll: true,
      padEnds: true,
      enlargeCenterPage: true,
      viewportFraction: 0.75,
      enlargeFactor: 0.2,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Bedpresser & Kurs',
          style: OnlineTheme.header(),
        ),
        const SizedBox(height: 24),
        CarouselSlider(
          options: options,
          items: List.generate(
            filteredModels.length,
            (i) {
              return BedpressCard(
                model: filteredModels[i],
              );
            },
          ),
        ),
      ],
    );
  }
}

class BedpressCard extends StatelessWidget {
  const BedpressCard({
    super.key,
    required this.model,
  });

  final EventModel model;

  static const monthsNorwegian = [
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

  String formatDate() {
    final date = DateTime.parse(model.startDate);
    final day = date.day.toString().padLeft(2, '0');
    final month = monthsNorwegian[date.month - 1]; // Norwegian month
    return "$day. $month";
  }

  String truncateWithEllipsis(String text, int maxLength) {
    return (text.length <= maxLength) ? text : '${text.substring(0, maxLength)}...';
  }

  void showInfo() {
    AppNavigator.navigateToPage(EventPageDisplay(
      model: model,
    ));
  }

  String getEventTypeDisplay() {
    // Check if the eventTypeDisplay is 'Bedriftspresentasjon'
    return model.eventTypeDisplay == 'Bedriftspresentasjon' ? 'Bedpress' : model.eventTypeDisplay;
  }

  BoxDecoration badgeDecoration(int eventType) {
    return BoxDecoration(
      color: OnlineTheme.yellow.darken(40),
      borderRadius: OnlineTheme.buttonRadius,
      border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.yellow, width: 2)),
    );
  }

  Color getColor(int eventType) {
    return OnlineTheme.yellow;
  }

  Widget typeBadge() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: badgeDecoration(model.eventType),
      child: Center(
        child: Text(
          getEventTypeDisplay(),
          style: OnlineTheme.textStyle(weight: 5, size: 14, color: getColor(model.eventType)),
        ),
      ),
    );
  }

  String participants() {
    if (model.numberOfSeatsTaken == null && model.maxCapacity == null) return '∞';

    return '${model.numberOfSeatsTaken ?? 0}/${model.maxCapacity ?? 0}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: showInfo,
      childBuilder: (context, hover, pointerDown) {
        return Stack(
          children: [
            Container(
              width: 250,
              height: 300,
              decoration: const BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(width: 2, color: OnlineTheme.grayBorder),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: OnlineTheme.grayBorder),
                        ),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
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
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        truncateWithEllipsis(model.title, 35),
                        style: OnlineTheme.subHeader(),
                      ),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconLabel(icon: IconType.dateTime, label: formatDate()),
                          IconLabel(icon: IconType.usersFilled, label: participants(), iconSize: 16),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  typeBadge(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
