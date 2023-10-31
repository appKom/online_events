import 'package:flutter/material.dart';

import '/pages/upcoming_events/profile_button.dart';
import '/pages/upcoming_events/upcoming_events_page.dart';
import '/theme.dart';

const double above = 25;
const double below = 25;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return OnlineScaffold(
      content: Column(
        children: [
          const SizedBox(height: 30),
          const Center(
            child: Text(
              'Fredrik Hansteen',
              style: TextStyle(
                fontFamily: OnlineTheme.font,
                fontSize: 24,
                color: Colors.white,
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
              // decoration: const BoxDecoration(
              //   shape: BoxShape.circle,
              //   color: OnlineTheme.blue1,
              // ),
              // child: const Center(
              //   child: Icon(
              //     Icons.person,
              //     color: Colors.white,
              //     size: 100,
              //   ),
              // ),
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
            ),
          ),
          // const SizedBox(height: above),
          Padding(
            padding: const EdgeInsets.only(top: above, bottom: below),
            child: textInput('Brukernavn', 'Fredrikbobo'),
          ),
          // const SizedBox(height: below),
          const Divider(
            color: OnlineTheme.gray14,
            thickness: 1,
          ),
          const SizedBox(height: above),
          textInput('Telefon', '+47 123 45 678'),
          const SizedBox(height: below),
          const Divider(
            color: OnlineTheme.gray14,
            thickness: 1,
          ),
          const SizedBox(height: above),
          textInput('E-post', 'fredrik@stud.ntnu.no'),
          const SizedBox(height: below),
          const Divider(
            color: OnlineTheme.gray14,
            thickness: 1,
          ),
          const SizedBox(height: 40),
          const Text(
            'Studie',
            style: TextStyle(
              fontFamily: OnlineTheme.font,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: above),
          textInput('Klassetrinn', '1. klasse'),
          const SizedBox(height: below),
          const Divider(
            color: OnlineTheme.gray14,
            thickness: 1,
          ),
          const SizedBox(height: above),
          textInput('Startår', '2023'),
          const SizedBox(height: below),
          const Divider(
            color: OnlineTheme.gray14,
            thickness: 1,
          ),
          const SizedBox(height: above),
          const Text(
            'Studieløp',
            style: TextStyle(
              fontFamily: OnlineTheme.font,
              fontSize: 13,
              color: OnlineTheme.gray11,
            ),
          ),
          const SizedBox(height: below),
          const Divider(
            color: OnlineTheme.gray14,
            thickness: 1,
          ),
          const SizedBox(height: 40),
          const Text(
            'Eksterne sider',
            style: TextStyle(
              fontFamily: OnlineTheme.font,
              fontSize: 20,
              color: OnlineTheme.gray11,
            ),
          ),
          const SizedBox(height: below),
          textInput('Github', 'Github'),
          const SizedBox(height: below),
          const Divider(
            color: OnlineTheme.gray14,
            thickness: 1,
          ),
          const SizedBox(height: above),
          textInput('Linkedin', 'Linkedin'),
          const SizedBox(height: below),
          const Divider(
            color: OnlineTheme.gray14,
            thickness: 1,
          ),
          const SizedBox(height: above),
          textInput('Hjemmeside', 'online.ntnu.no'),
          const SizedBox(height: below),

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
                foregroundColor: Colors.white, backgroundColor: OnlineTheme.red1, // Set the text color to white
                minimumSize: const Size(double.infinity, 50), // Set the button to take the full width
              ),
              child: const Text('Logg Ut'),
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
          height: 50,
          child: TextField(
            cursorColor: OnlineTheme.gray8,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: const TextStyle(
                fontFamily: OnlineTheme.font,
                fontSize: 16.0,
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
