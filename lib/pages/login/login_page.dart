import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../home/home_page.dart';
import '../home/profile_button.dart';
import '/pages/login/forgotten_password_page.dart';
import 'package:online_events/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding + const EdgeInsets.symmetric(horizontal: 25);

    return Material(
      color: OnlineTheme.background,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 17),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to another page when the SVG image is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()), // Replace with your page class
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/header.svg',
                    height: 36,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                const ProfileButton()
              ],
            ),
            const SizedBox(height: 60),
            Container(
              width: 300,
              height: 330,
              padding: const EdgeInsets.only(bottom: 20),
              margin: const EdgeInsets.only(right: 20),
              child: Stack(
                children: [
                  const Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      height: 111,
                      child: Text(
                        'Log inn to your Online Account',
                        style: OnlineTheme.logInnPageHeader,
                      )),
                  const Positioned(
                      left: 15,
                      top: 45,
                      child: Text(
                        'Email:',
                        style: OnlineTheme.logInnPageEmail,
                      )),
                  const Positioned(
                      left: 15,
                      right: 15,
                      top: 75,
                      child: TextField(
                        obscureText: false,
                        style: OnlineTheme.logInnPageEmail,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: OnlineTheme.gray14,
                            hintText: 'Enter your Email',
                            hintStyle: OnlineTheme.logInnPageInput,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: OnlineTheme.gray15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: OnlineTheme.gray15),
                            )),
                      )),
                  const Positioned(
                      left: 15,
                      top: 130,
                      child: Text(
                        'Password:',
                        style: OnlineTheme.logInnPageEmail,
                      )),
                  const Positioned(
                      left: 15,
                      right: 15,
                      top: 160,
                      child: TextField(
                        obscureText: true,
                        style: OnlineTheme.logInnPageEmail,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: OnlineTheme.gray14,
                            hintText: 'Enter your password',
                            hintStyle: OnlineTheme.logInnPageInput,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: OnlineTheme.gray15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: OnlineTheme.gray15),
                            )),
                      )),
                  Positioned(
                      left: 15,
                      right: 160,
                      top: 230,
                      height: 65,
                      child: GestureDetector(
                        onTap: () {
                          loggedIn = true; // Set the loggedIn to true when the green button is clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const HomePage()), // Replace with the page you want to navigate to
                          );
                          // Here you can also navigate to another page or show a dialog if needed
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: OnlineTheme.green3,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Center(
                            child: Text(
                              'Log Inn',
                              style: OnlineTheme.logInnPageButton,
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                    left: 160,
                    right: 15,
                    top: 230,
                    height: 65,
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to another page when the red box is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgottenPasswordPage()), // Replace with the page you want to navigate to
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: OnlineTheme.red1,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            'Forgotten Password',
                            style: OnlineTheme.logInnPageButton,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
