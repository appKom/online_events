import 'dart:ui';

import 'package:flutter/material.dart';

import '/router.dart';

abstract class DarkOverlay extends ModalRoute<void> {
  Widget content(BuildContext context, Animation<double> animation);

  @override
  Color? get barrierColor => Colors.black.withValues(alpha: 0.8);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  void show(BuildContext context) {
    rootNavigator.currentState!.push(this);
  }

  void hide() {
    rootNavigator.currentState!.pop();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final query = MediaQuery.of(context);
    final padding = query.padding;

    const blur = 10.0;

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: blur,
        sigmaY: blur,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: padding,
          child: Center(
            child: content(
              context,
              animation,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
