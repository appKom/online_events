import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:online/components/icon_label.dart';
import 'package:online/components/image_default.dart';
import 'package:online/services/app_navigator.dart';

import '../../theme/themed_icon.dart';
import '/components/animated_button.dart';
import '/components/skeleton_loader.dart';
import '/core/models/event_model.dart';
import '/pages/event/event_page.dart';
import '/theme/theme.dart';

class Bedpres extends StatelessWidget {
  const Bedpres({
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
        CarouselSlider(
          options: _carouselOptions,
          items: List.generate(3, (i) {
            return const SkeletonLoader(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  static final _carouselOptions = CarouselOptions(
    height: 320,
    enableInfiniteScroll: true,
    padEnds: true,
    enlargeCenterPage: true,
    viewportFraction: 0.75,
    enlargeFactor: 0.2,
  );

  @override
  Widget build(BuildContext context) {
    final futureEvents = models.where((event) {
      final eventDate = DateTime.parse(event.endDate);
      return eventDate.isAfter(DateTime.now());
    }).toList();

    final filteredModels = futureEvents.where((model) => model.eventType == 2 || model.eventType == 3).toList();

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
          options: _carouselOptions,
          items: List.generate(
            filteredModels.length,
            (i) {
              return BedpresCard(
                model: filteredModels[i],
              );
            },
          ),
        ),
      ],
    );
  }
}

class BedpresCard extends StatelessWidget {
  const BedpresCard({
    super.key,
    required this.model,
  });

  final EventModel model;

  static const monthsNorwegian = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mai',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Okt',
    'Nov',
    'Des',
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
    return model.eventTypeDisplay == 'Bedriftspresentasjon' ? 'Bedpres' : model.eventTypeDisplay;
  }

  BoxDecoration badgeDecoration(int eventType) {
    if (eventType == 2) {
      return BoxDecoration(
        color: OnlineTheme.red.darken(40),
        borderRadius: OnlineTheme.buttonRadius,
        border: const Border.fromBorderSide(BorderSide(color: OnlineTheme.red, width: 2)),
      );
    }

    // eventType == 3
    return BoxDecoration(
      color: OnlineTheme.blue2.darken(40),
      borderRadius: OnlineTheme.buttonRadius,
      border: const Border.fromBorderSide(
        BorderSide(color: OnlineTheme.blue2, width: 2),
      ),
    );
  }

  Color getColor(int eventType) {
    switch (eventType) {
      case 2:
        return OnlineTheme.red;
      case 3:
        return OnlineTheme.blue2;
      default:
        return OnlineTheme.white;
    }
  }

  Widget typeBadge() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            : const ImageDefault(),
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
