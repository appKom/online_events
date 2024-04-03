import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:online/pages/games/oddsen/oddsen_info_page.dart';
import 'package:online/theme/theme.dart';

import '../../../components/animated_button.dart';
import '../../../services/app_navigator.dart';

class OddsenPage extends StatefulWidget {
  const OddsenPage({super.key});

  @override
  OddsenPageState createState() => OddsenPageState();
}

class OddsenPageState extends State<OddsenPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation _colorAnimation;
  late Animation _antiColorAnimation;
  String _randomNumber = '';
  bool isSucsess = false;
  bool isNotSucess = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.green).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _antiColorAnimation = ColorTween(begin: OnlineTheme.red, end: OnlineTheme.purple1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }

  void _animateNumberBeforeFinal(int finalNumber) {
    const int animationSteps = 100;
    Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {
      if (timer.tick < animationSteps) {
        setState(() {
          _randomNumber = (Random().nextInt(finalNumber) + 1).toString();
        });
      } else {
        timer.cancel();
        final int userNumber = int.tryParse(_controller.text) ?? 0;
        final bool isSuccess = finalNumber == userNumber;

        setState(() {
          _randomNumber = finalNumber.toString();
          isSucsess = isSuccess;
          isNotSucess = !isSuccess;
          if (isSucsess) {
            _animationController.forward().then((value) => _animationController.reverse());
          }
        });
      }
    });
  }

  void _generateRandomNumber() {
    final int userNumber = int.tryParse(_controller.text) ?? 0;
    final int randomNumber = Random().nextInt(userNumber) + 1;
    _animateNumberBeforeFinal(randomNumber);
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + OnlineTheme.horizontalPadding;

    return Scaffold(
      backgroundColor: OnlineTheme.background,
      body: Container(
        padding: MediaQuery.of(context).padding,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [OnlineTheme.hundredGradientStartColor, OnlineTheme.hundredGradientEndColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.9],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                AnimatedButton(onTap: () {
                  OddsenOverlay().show(context);
                }, childBuilder: (context, hover, pointerDown) {
                  return const Icon(
                    Icons.info_outline,
                    color: OnlineTheme.white,
                    size: 32,
                  );
                }),
                const Spacer(),
                AnimatedButton(onTap: () {
                  AppNavigator.pop();
                }, childBuilder: (context, hover, pointerDown) {
                  return const Icon(
                    Icons.close_outlined,
                    color: OnlineTheme.white,
                    size: 32,
                  );
                }),
              ],
            ),
            if (isSucsess) Icon(Icons.check_circle, color: _colorAnimation.value, size: 48),
            if (isNotSucess) Icon(Icons.check_circle, color: _antiColorAnimation.value, size: 48),
            const SizedBox(
              height: 24,
            ),
            if (_randomNumber.isNotEmpty)
              Text(
                _randomNumber,
                style: OnlineTheme.textStyle(size: 32),
              ),
            Text(
              'Skriv et nummer',
              style: OnlineTheme.textStyle(),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Skriv et tall',
                  hintStyle: OnlineTheme.textStyle(),
                  labelStyle: OnlineTheme.textStyle(),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: OnlineTheme.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: OnlineTheme.blue1),
                  ),
                ),
                style: OnlineTheme.textStyle(),
                onSubmitted: (_) => _generateRandomNumber(),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            AnimatedButton(
              onTap: () async {
                if (int.tryParse(_controller.text) == null) {
                  return;
                }

                setState(() {
                  isSucsess == false;
                });
                _generateRandomNumber();
              },
              childBuilder: (context, hover, pointerDown) {
                return Padding(
                  padding: EdgeInsets.only(left: padding.left, right: padding.right),
                  child: Container(
                    height: OnlineTheme.buttonHeight,
                    decoration: BoxDecoration(
                      color: OnlineTheme.green1.darken(40),
                      borderRadius: OnlineTheme.buttonRadius,
                      border: const Border.fromBorderSide(
                        BorderSide(color: OnlineTheme.green1, width: 2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Start!',
                        style: OnlineTheme.textStyle(weight: 5, color: OnlineTheme.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
