import 'package:flutter/material.dart';
import 'package:online/components/separator.dart';
import 'package:online/pages/games/bits/bits_page.dart';
import '../../../components/animated_button.dart';
import '../../../services/app_navigator.dart';
import '../../../theme/theme.dart';

class BitsHomePage extends StatefulWidget {
  const BitsHomePage({super.key});

  @override
  BitsHomePageState createState() => BitsHomePageState();
}

class BitsHomePageState extends State<BitsHomePage> {
  List<int> playerNumbers = [1, 2];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 2; i++) {
      controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildPlayerField(int number) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controllers[number - 1],
            decoration: InputDecoration(
              labelText: 'Deltaker $number',
              labelStyle: const TextStyle(color: OnlineTheme.white),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: OnlineTheme.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: OnlineTheme.white),
              ),
            ),
            style: OnlineTheme.textStyle(),
          ),
        ),
        if (number > 2)
          IconButton(
            icon: const Icon(Icons.close, color: OnlineTheme.white),
            onPressed: () => _removePlayerField(number),
          ),
      ],
    );
  }

  OverlayEntry? _overlayEntry;

  void showErrorTop(String message) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 160,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              gradient: OnlineTheme.redGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              message,
              style: OnlineTheme.textStyle(size: 20),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(const Duration(seconds: 5), () {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  void _addPlayerField() {
    setState(() {
      if (playerNumbers.length < 11) {
        int nextNumber = playerNumbers.isNotEmpty ? playerNumbers.last + 1 : 1;
        playerNumbers.add(nextNumber);
        controllers.add(TextEditingController());
      }
    });
  }

  void _removePlayerField(int number) {
    setState(() {
      int index = playerNumbers.indexOf(number);
      if (index != -1) {
        playerNumbers.removeAt(index);
        controllers[index].dispose();
        controllers.removeAt(index);
      }
    });
  }

  bool get _shouldShowStartButton {
    int filledFields =
        controllers.where((c) => c.text.trim().isNotEmpty).length;
    return filledFields >= 2;
  }

  void _startGame() {
    bool anyFieldEmpty =
        controllers.any((controller) => controller.text.trim().isEmpty);

    if (anyFieldEmpty) {
      return showErrorTop("Deltakerfeltene må være fylt ut");
    }

    List<String> playerNames = controllers.map((c) => c.text.trim()).toList();
    AppNavigator.globalNavigateTo(BitsGame(playerNames: playerNames));
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  OnlineTheme.purple1,
                  Color.fromARGB(255, 225, 10, 189)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.9],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: MediaQuery.of(context).padding,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(children: [
                  const SizedBox(width: 10),
                  AnimatedButton(onTap: () {
                    AppNavigator.pop();
                  }, childBuilder: (context, hover, pointerDown) {
                    return const Icon(
                      Icons.close_outlined,
                      color: OnlineTheme.white,
                      size: 30,
                    );
                  }),
                  const Spacer(),
                ]),
                Text(
                  'Bits',
                  style: OnlineTheme.textStyle(size: 32, weight: 5),
                ),
                const Separator(margin: 16),
                Text(
                  'Fyll inn navnene på deltakerne',
                  style: OnlineTheme.textStyle(),
                ),
                const SizedBox(height: 12),
                ...playerNumbers.map(_buildPlayerField),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    if (playerNumbers.length < 11)
                      Expanded(
                        child: AnimatedButton(
                          onTap: () {
                            _addPlayerField();
                          },
                          childBuilder: (context, hover, pointerDown) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: padding.left, right: padding.right),
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 98, 6)
                                      .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: const Border.fromBorderSide(
                                      BorderSide(
                                          color: OnlineTheme.white, width: 2)),
                                ),
                                child: Text(
                                  'Legg til spiller',
                                  style: OnlineTheme.textStyle(
                                    weight: 5,
                                    color: OnlineTheme.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(width: 10),
                    if (_shouldShowStartButton)
                      Expanded(
                        child: AnimatedButton(
                          onTap: () async {
                            _startGame();
                          },
                          childBuilder: (context, hover, pointerDown) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: padding.left, right: padding.right),
                              child: Container(
                                height: OnlineTheme.buttonHeight,
                                decoration: BoxDecoration(
                                  color: OnlineTheme.green1.darken(40),
                                  borderRadius: OnlineTheme.buttonRadius,
                                  border: const Border.fromBorderSide(
                                    BorderSide(
                                        color: OnlineTheme.green1, width: 2),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Start Spillet',
                                    style: OnlineTheme.textStyle(
                                        weight: 5, color: OnlineTheme.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
