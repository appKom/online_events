import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:online/components/icon_label.dart';
import 'package:online/components/image_default.dart';

import '/components/animated_button.dart';
import '/components/skeleton_loader.dart';
import '/core/models/event_model.dart';
import '/theme/theme.dart';
import '../../core/client/client.dart';
import '../../theme/themed_icon.dart';

class Bedpres extends StatelessWidget {
  const Bedpres({
    super.key,
    required this.models,
  });

  final Map<int, EventModel> models;

  static Widget skeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Bedriftpresentasjoner og Kurs',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
        ),
        const SizedBox(height: 24),
        CarouselSlider(
          options: getCarouselOptions(context),
          items: List.generate(3, (i) {
            return const SkeletonLoader(
              width: 250,
              height: 300,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  static getCarouselOptions(BuildContext context) {
    final isMobile = OnlineTheme.isMobile(context);

    return CarouselOptions(
      height: 320,
      enableInfiniteScroll: true,
      padEnds: true,
      enlargeCenterPage: false,
      viewportFraction: isMobile ? 0.75 : 0.3,
      clipBehavior: Clip.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final List<EventModel> futureEvents = [];

    for (MapEntry<int, EventModel> entry in Client.eventsCache.value.entries) {
      final event = entry.value;
      final eventDate = DateTime.parse(event.endDate);

      if (eventDate.isAfter(now)) {
        futureEvents.add(event);
      }
    }

    final filteredModels = futureEvents.where((model) => model.eventType == 2 || model.eventType == 3).toList();

    if (filteredModels.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bedpresser & Kurs',
            style: OnlineTheme.header(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24 + 24),
          Center(
            child: Text(
              'Ingen bedpresser eller kurs tilgjengelig',
              style: OnlineTheme.textStyle(),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Bedpresser & Kurs',
          style: OnlineTheme.header(),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        CarouselSlider(
          options: getCarouselOptions(context),
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

  void showInfo(BuildContext context) {
    context.go('/event/${model.id}');
  }

  String getEventTypeDisplay() {
    // Check if the eventTypeDisplay is 'Bedriftspresentasjon'
    return model.eventTypeDisplay == 'Bedriftspresentasjon' ? 'Bedpres' : model.eventTypeDisplay;
  }

  BoxDecoration badgeDecoration(int eventType) {
    if (eventType == 2) {
      return BoxDecoration(
        color: OnlineTheme.current.negBg,
        borderRadius: OnlineTheme.buttonRadius,
        border: Border.fromBorderSide(BorderSide(color: OnlineTheme.current.neg, width: 2)),
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
        return OnlineTheme.current.neg;
      case 3:
        return OnlineTheme.blue2;
      default:
        return OnlineTheme.current.fg;
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
      onTap: () => showInfo(context),
      childBuilder: (context, hover, pointerDown) {
        return Stack(
          children: [
            Container(
              width: 250,
              height: 300,
              decoration: BoxDecoration(
                border: Border.fromBorderSide(
                  BorderSide(width: 2, color: OnlineTheme.current.border),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: OnlineTheme.current.bg),
                        ),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: model.images.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: model.images.first.md,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const SkeletonLoader(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              )
                            : const ImageDefault(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        truncateWithEllipsis(model.title, 38),
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
                          IconLabel(icon: IconType.users, label: participants(), iconSize: 16),
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
