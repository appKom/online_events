import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '/components/animated_button.dart';
import '/components/image_default.dart';
import '/components/skeleton_loader.dart';
import '/core/models/hobby_model.dart';
import '/pages/hobbies/hobby_page.dart';
import '/services/app_navigator.dart';
import '/theme/theme.dart';

class Hobbies extends StatelessWidget {
  const Hobbies({
    super.key,
    required this.hobbies,
  });

  final Set<HobbyModel> hobbies;

  static Widget skeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Interessegrupper',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
        ),
        const SizedBox(height: 24),
        CarouselSlider(
          options: getCarouselOptions(context),
          items: List.generate(3, (i) {
            return const SkeletonLoader(
              width: 150,
              height: 150,
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<HobbyModel> interesseGrupper =
        hobbies.where((hobby) => hobby.active && !hobby.title.contains("[inaktiv]")).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          'Interessegrupper',
          style: OnlineTheme.textStyle(size: 20, weight: 7),
        ),
        const SizedBox(height: 24),
        CarouselSlider(
          options: getCarouselOptions(context),
          items: List.generate(
            interesseGrupper.length,
            (i) {
              return HobbiesCard(
                model: interesseGrupper[i],
              );
            },
          ),
        ),
      ],
    );
  }

  static getCarouselOptions(BuildContext context) {
    final isMobile = OnlineTheme.isMobile(context);

    return CarouselOptions(
      height: 150,
      enableInfiniteScroll: true,
      padEnds: true,
      enlargeCenterPage: isMobile,
      viewportFraction: isMobile ? 0.45 : 0.3,
      enlargeFactor: 0.2,
      clipBehavior: Clip.none,
    );
  }
}

class HobbiesCard extends StatelessWidget {
  const HobbiesCard({super.key, required this.model});

  final HobbyModel model;

  void showInfo() {
    AppNavigator.navigateToPage(HobbyPage(hobby: model));
  }

  Widget defaultWithBorder() {
    return Container(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(width: 2, color: OnlineTheme.current.border),
        ),
        borderRadius: OnlineTheme.buttonRadius,
      ),
      child: const ImageDefault(),
    );
  }

  Widget hobbyIcon() {
    if (model.image?.original == null) {
      return ClipOval(
        child: Container(
          color: OnlineTheme.current.bg,
          child: const ClipOval(
            child: SizedBox(
              height: 150,
              width: 150,
              child: ImageDefault(),
            ),
          ),
        ),
      );
    }

    return ClipOval(
      child: Container(
        color: OnlineTheme.current.fg,
        child: ClipOval(
          child: SizedBox(
            height: 150,
            width: 150,
            child: CachedNetworkImage(
              imageUrl: model.image!.xs,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SkeletonLoader(),
              errorWidget: (context, url, error) => defaultWithBorder(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: showInfo,
      childBuilder: (context, hover, pointerDown) {
        return Stack(children: [
          hobbyIcon(),
        ]);
      },
    );
  }

  Widget typeBadge() {
    final theme = OnlineTheme.current;

    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: model.active ? theme.posBg : theme.negBg,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.fromBorderSide(BorderSide(color: model.active ? theme.pos : theme.neg, width: 2)),
      ),
      child: Center(
        child: Text(
          model.active ? 'Aktiv' : 'Inaktiv',
          style: OnlineTheme.textStyle(weight: 5, size: 14, color: model.active ? theme.posFg : theme.negFg),
        ),
      ),
    );
  }
}
