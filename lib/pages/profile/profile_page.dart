import 'package:flutter/material.dart';

import '/pages/upcoming_events/profile_button.dart';
import '/pages/upcoming_events/upcoming_events_page.dart';
import '/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const aboveBelowPadding = EdgeInsets.only(top: 16, bottom: 16);

    return OnlineScaffold(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'Fredrik Hansteen',
              style: TextStyle(
                fontFamily: OnlineTheme.font,
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/images/better_profile_picture.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Center(
            child: Text(
              'Oppdater profilbilde og info',
              style: TextStyle(
                fontFamily: OnlineTheme.font,
                fontSize: 12,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: OnlineTheme.white,
                  foregroundColor: OnlineTheme.blue1,
                ),
                child: const Text('Avbryt'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: OnlineTheme.blue1,
                  foregroundColor: OnlineTheme.white,
                ),
                child: const Text('Lagre'),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const Text(
            'Kontakt',
            style: TextStyle(
              fontFamily: OnlineTheme.font,
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: aboveBelowPadding,
            child: textInput('Brukernavn', 'Fredrikbobo'),
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
          const SizedBox(height: 24),
          const Separator(),
          const SizedBox(height: 40),
          const Text(
            'Studie',
            style: TextStyle(
              fontFamily: OnlineTheme.font,
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: aboveBelowPadding,
            child: textInput('Klassetrinn', '1. klasse'),
          ),
          Padding(
            padding: aboveBelowPadding,
            child: textInput('Startår', '2023'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Studieløp',
            style: TextStyle(
              fontFamily: OnlineTheme.font,
              fontSize: 16,
              color: OnlineTheme.gray11,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: CustomPaint(
              painter: StudyCoursePainter(year: 5.5),
            ),
          ),
          const SizedBox(height: 40),
          const Separator(),
          const SizedBox(height: 40),
          const Text(
            'Eksterne sider',
            style: TextStyle(
              fontFamily: OnlineTheme.font,
              fontSize: 20,
              color: OnlineTheme.gray11,
              fontWeight: FontWeight.bold,
            ),
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
          const Separator(),
          const SizedBox(height: 40), // Space from the previous content
          Center(
            child: ElevatedButton(
              onPressed: () {
                loggedIn = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpcomingEventsPage()), // Replace with your page class
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: OnlineTheme.white, backgroundColor: OnlineTheme.red1, // Set the text color to white
                minimumSize: const Size(double.infinity, 50), // Set the button to take the full width
              ),
              child: const Text(
                'Logg Ut',
                style: TextStyle(
                  fontFamily: OnlineTheme.font,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40), // Space at the bottom
        ],
      ),
    );
  }

  Widget textInput(String label, String placeholder) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: OnlineTheme.font,
            fontSize: 16,
            color: OnlineTheme.gray11,
          ),
        ),
        SizedBox(
          width: 200,
          height: 40,
          child: TextField(
            cursorColor: OnlineTheme.gray8,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontFamily: OnlineTheme.font,
                fontSize: 16,
                color: Color(0xFF4C566A),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(color: Color(0xFF4C566A)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                borderSide: BorderSide(color: OnlineTheme.white),
              ),
              filled: true,
              fillColor: OnlineTheme.gray0,
            ),
            style: const TextStyle(
              fontFamily: OnlineTheme.font,
              fontSize: 16.0,
              color: OnlineTheme.gray8,
            ),
          ),
        ),
      ],
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF000212),
            Color(0xFF2E3440),
            Color(0xFF000212),
          ],
        ),
      ),
    );
  }
}

class StudyCoursePainter extends CustomPainter {
  final double year;

  StudyCoursePainter({super.repaint, required this.year});

  @override
  void paint(Canvas canvas, Size size) {
    const gray = Color(0xFF153E75);
    const green = Color(0xFF36B37E);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = gray;

    final cy = size.height / 2; // Center Y

    final fraction = size.width / 6;
    final segment1 = fraction * 3 - 18;
    final segment2 = fraction * 2 + 9;
    final segment3 = fraction - 9;

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
