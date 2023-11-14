import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/pages/home/home_page.dart';

import '/components/online_scaffold.dart';
import '/components/online_header.dart';
import '/theme/themed_icon_button.dart';
import '../../services/page_navigator.dart';
import '/components/separator.dart';
import '/components/navbar.dart';
import '/theme/themed_icon.dart';
import '/theme/theme.dart';
import '/main.dart';

class ProfilePage extends ScrollablePage {
  const ProfilePage({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget content(BuildContext context) {
    const aboveBelowPadding = EdgeInsets.only(top: 16, bottom: 16);

    final headerStyle = OnlineTheme.textStyle(
      size: 20,
      weight: 7,
    );

    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: OnlineHeader.height(context) + 40),
          Center(
            child: Text(
              'Fredrik Hansteen',
              style: OnlineTheme.textStyle(
                size: 20,
                weight: 7,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Center(
              child: 
              AnimatedButton(child: 
              SizedBox(
                width: 125,
                height: 125,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/images/better_profile_picture.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Kontakt',
            style: headerStyle,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: aboveBelowPadding,
            child: constValueTextInput('NTNU-brukernavn', 'fredrikbobo'),
          ),
          // const Separator(),
          Padding(
            padding: aboveBelowPadding,
            child: textInput('Telefon', '+47 123 45 678'),
          ),
          // const Separator(),
          Padding(
            padding: aboveBelowPadding,
            child: textInput('E-post', 'fredrik@stud.ntnu.no'),
          ),
          const Separator(margin: 40),
          Text(
            'Studie',
            style: headerStyle,
          ),
          const SizedBox(height: 5),
          Padding(
            padding: aboveBelowPadding,
            child: constValueTextInput('Klassetrinn', '5. klasse'),
          ),
          Padding(
            padding: aboveBelowPadding,
            child: constValueTextInput('Startår', '2022'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      'Bachelor',
                      style: OnlineTheme.textStyle(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Master',
                      style: OnlineTheme.textStyle(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      'PhD',
                      style: OnlineTheme.textStyle(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: CustomPaint(
              painter: StudyCoursePainter(year: 5.5),
            ),
          ),
          const Separator(margin: 40),
          Text(
            'Eksterne sider',
            style: headerStyle,
          ),
          Padding(
            padding: aboveBelowPadding,
            child: textInput('Github', 'Github'),
          ),
          Padding(
            padding: aboveBelowPadding,
            child: textInput('Linkedin', 'Linkedin'),
          ),
          Padding(
            padding: aboveBelowPadding,
            child: textInput('Hjemmeside', 'online.ntnu.no'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: AnimatedButton(
              onTap: () {
                loggedIn = false;
                PageNavigator.navigateTo(const HomePage());
              },
              childBuilder: (context, hover, pointerDown) {
                return Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: OnlineTheme.red1,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      'Logg Ut',
                      style: OnlineTheme.textStyle(weight: 5),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: Navbar.height(context)),
        ],
      ),
    );
  }

  Widget constValueTextInput(String label, String value) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: OnlineTheme.textStyle(),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: OnlineTheme.gray14,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Stack(children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: OnlineTheme.textStyle(
                        height: 1,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 40,
                  child: ThemedIconButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Clipboard.setData(ClipboardData(text: value));
                    },
                    size: 16,
                    icon: IconType.copy,
                    color: const Color(0xFF4C566A),
                    hoverColor: OnlineTheme.white,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget textInput(String label, String placeholder) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: OnlineTheme.textStyle(color: OnlineTheme.gray11),
            ),
          ),
          Expanded(
            child: TextField(
              cursorColor: OnlineTheme.gray8,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: OnlineTheme.textStyle(
                  color: const Color(0xFF4C566A),
                  height: 1,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: const BorderSide(color: Color(0xFF4C566A)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: const BorderSide(color: OnlineTheme.white),
                ),
                filled: true,
                fillColor: OnlineTheme.gray0,
              ),
              style: OnlineTheme.textStyle(
                color: OnlineTheme.white,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudyCoursePainter extends CustomPainter {
  final double year;

  StudyCoursePainter({super.repaint, required this.year});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final cy = size.height / 2; // Center Y

    final fraction = size.width / 6;
    final segment1 = fraction * 3 - 18;
    final segment2 = fraction * 2 + 9;

    final c1 = Offset(18, cy);
    final c2 = Offset(9 + (segment1 - 36) / 2, cy);
    final c3 = Offset((segment1 - 36), cy);

    final c4 = Offset(segment1 + 36, cy);
    final c5 = Offset(segment1 + segment2 - 36, cy);

    final c6 = Offset(size.width - 18, cy);

    line(year >= 1, c1, c2, canvas, paint);
    circle(year >= 1, c1, canvas, paint);
    line(year > 2, c2, c3, canvas, paint);
    circle(year > 1, c2, canvas, paint);
    line(year > 3, c3, Offset(segment1, cy), canvas, paint);
    circle(year > 2, c3, canvas, paint);

    line(year > 3, Offset(segment1, 0), Offset(segment1, size.height), canvas, paint);

    line(year >= 4, Offset(segment1 + 1.5, cy), c4, canvas, paint);
    line(year >= 5, c4, c5, canvas, paint);
    circle(year > 4, c4, canvas, paint);
    line(year > 5, c5, Offset(segment1 + segment2, cy), canvas, paint);
    circle(year >= 5, c5, canvas, paint);

    line(year > 5, Offset(segment1 + segment2, 0), Offset(segment1 + segment2, size.height), canvas, paint);

    line(year >= 6, Offset(segment1 + segment2 + 1.5, cy), c6, canvas, paint);
    circle(year >= 6, c6, canvas, paint);
  }

  void line(bool active, Offset start, Offset end, Canvas canvas, Paint paint) {
    final color = active ? green : gray;
    paint.color = color;
    canvas.drawLine(start, end, paint);
  }

  // static const gray = Color(0xFF153E75);
  static const gray = OnlineTheme.gray0;
  static const green = Color(0xFF36B37E);

  void circle(bool active, Offset c, Canvas canvas, Paint paint) {
    final color = active ? green : gray;

    paint.color = OnlineTheme.background;
    paint.style = PaintingStyle.fill;

    canvas.drawCircle(c, 15, paint);

    paint.color = color;
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(c, 16, paint);

    paint.style = PaintingStyle.fill;
    canvas.drawCircle(c, 8, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
