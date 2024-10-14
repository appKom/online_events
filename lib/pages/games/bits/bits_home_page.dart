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
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    final theme = OnlineTheme.current;

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controllers[number - 1],
              decoration: InputDecoration(
                labelText: 'Deltaker $number',
                labelStyle: TextStyle(color: theme.fg),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.fg),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.fg),
                ),
              ),
              style: OnlineTheme.textStyle(),
            ),
          ),
          if (number > 2 && number == playerNumbers.last)
            IconButton(
              icon: Icon(Icons.close, color: theme.fg),
              onPressed: () => _removePlayerField(number),
            ),
        ],
      ),
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
    int filledFields = controllers.where((c) => c.text.trim().isNotEmpty).length;
    return filledFields >= 2;
  }

  void _startGame() {
    bool anyFieldEmpty = controllers.any((controller) => controller.text.trim().isEmpty);

    if (anyFieldEmpty) {
      return showErrorTop("Deltakerfeltene må være fylt ut");
    }

    List<String> playerNames = controllers.map((c) => c.text.trim()).toList();
    AppNavigator.navigateToPage(BitsGame(playerNames: playerNames), withHeaderNavbar: false);
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    final theme = OnlineTheme.current;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [OnlineTheme.purple1, Color.fromARGB(255, 225, 10, 189)],
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
                    return Icon(
                      Icons.close_outlined,
                      color: theme.fg,
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
                              padding: EdgeInsets.only(left: padding.left, right: padding.right),
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 248, 98, 6).withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.fromBorderSide(BorderSide(color: theme.fg, width: 2)),
                                ),
                                child: Text(
                                  'Legg til spiller',
                                  style: OnlineTheme.textStyle(
                                    weight: 5,
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
                              padding: EdgeInsets.only(left: padding.left, right: padding.right),
                              child: Container(
                                height: OnlineTheme.buttonHeight,
                                decoration: BoxDecoration(
                                  color: theme.posBg,
                                  borderRadius: OnlineTheme.buttonRadius,
                                  border: Border.fromBorderSide(
                                    BorderSide(color: theme.pos, width: 2),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Start Spillet',
                                    style: OnlineTheme.textStyle(weight: 5, color: theme.fg),
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
