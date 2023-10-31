import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/pages/upcoming_events/upcoming_events_page.dart';
import 'package:online_events/pages/upcoming_events/profile_button.dart';
import '/theme.dart';

const double above = 25;
const double below = 25;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    

    return Material(
      color: OnlineTheme.background,
      child: SingleChildScrollView (
        child: Padding(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 17),
              SvgPicture.asset(
                'assets/header.svg',
                height: 48,
              ),
              const SizedBox(height: 30),
              AppBar(
                actionsIconTheme: const IconThemeData(color: OnlineTheme.background),
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle_rounded),
                    SizedBox(width: 8),
                    Text('Min profil'),
                    SizedBox(width: 25,)
                  ]
                ),
                centerTitle: true,
                backgroundColor: OnlineTheme.background,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  tooltip: 'Menu Icon',
                  onPressed: () {

                  },
                ),
                actions: const [
                  Icon(Icons.menu),
                ],
              ),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Fornavn Etternavn',
                  style: TextStyle(
                    fontFamily: OnlineTheme.font,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Container(
                  width: 100,
                  height: 100, 
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: OnlineTheme.blue1, 
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white, 
                      size: 100,
                    ),
                  ),
                )

              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'Update your photo and personal details',
                  style: TextStyle(
                    fontFamily: OnlineTheme.font,
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnlineTheme.white,
                      foregroundColor: OnlineTheme.blue1,
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: OnlineTheme.blue1,
                      foregroundColor: OnlineTheme.white,
                    ),
                    child: const Text('Save'),
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
              const SizedBox(height: above),
              textInput('Brukernavn'),
              const SizedBox(height: below),
              const Divider(
                color: OnlineTheme.gray14,
                thickness: 1,
              ),
              const SizedBox(height: above),
              textInput('Telefon'),
              const SizedBox(height: below),
              const Divider(
                color: OnlineTheme.gray14,
                thickness: 1,
              ),
              const SizedBox(height: above),
              textInput('E-post'),
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
              textInput('Klassetrinn'),
              const SizedBox(height: below),
              const Divider(
                color: OnlineTheme.gray14,
                thickness: 1,
              ),
              const SizedBox(height: above),
              textInput('Startår'),
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
              textInput('Github'),
              const SizedBox(height: below),
              const Divider(
                color: OnlineTheme.gray14,
                thickness: 1,
              ),
              const SizedBox(height: above),
              textInput('Linkedin'),
              const SizedBox(height: below),
              const Divider(
                color: OnlineTheme.gray14,
                thickness: 1,
              ),
              const SizedBox(height: above),
              textInput('Hjemmeside'),
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
                  child: const Text('Log Out'),
                ),
              ),
              const SizedBox(height: 40), // Space at the bottom
            ],
          ),
        ),
      )
    );
  }
  Widget textInput(String label) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: OnlineTheme.font,
            fontSize: 13,
            color: OnlineTheme.gray11,
          ),
          ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 200,
              height: 50.toDouble(),
              child: const TextField(
                cursorColor: OnlineTheme.gray8,
                decoration: InputDecoration(
                  hintText: 'Enter your text',
                  hintStyle: TextStyle(fontSize: 16.0, color: OnlineTheme.gray14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: OnlineTheme.gray14),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    borderSide: BorderSide(color: OnlineTheme.gray14),
                  ),
                  filled: true,
                  fillColor: OnlineTheme.gray13,
                ),
                
                style: TextStyle(
                  fontFamily: OnlineTheme.font,
                  fontSize: 16.0,
                  color: OnlineTheme.gray8,
                ),
              ),
            )
          ),
        ),
      ],
    ); 
  }
}
