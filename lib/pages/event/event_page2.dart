import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/theme/theme.dart';

import '../../components/online_header.dart';
import '../home/profile_button.dart';

class EventPage2 extends ScrollablePage {
  const EventPage2({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader(
      buttons: const [
        ProfileButton(),
      ],
    );
  }

  @override
  Widget content(BuildContext context) {
    const horizontalPadding = EdgeInsets.symmetric(horizontal: 25);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: OnlineHeader.height(context)),
        SizedBox(
          height: 267,
          child: Image.asset(
            'assets/images/heart.png',
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: horizontalPadding,
          child: Text(
            'Flørtekurs på A4',
            style: OnlineTheme.eventHeader,
          ),
        ),
        const SizedBox(height: 5),
        Padding(
            padding: horizontalPadding,
            child: Text(
              'Av Appkom',
              style: OnlineTheme.textStyle(),
            )),
        const SizedBox(height: 24),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Container(
              width: 222,
              height: 60,
              color: OnlineTheme.blue3,
              child: Stack(
                children: [
                  Positioned(
                      left: 10,
                      top: 4,
                      child: Text(
                        'Dec',
                        style: OnlineTheme.textStyle(weight: 3),
                      )),
                  Positioned(
                      left: 14,
                      bottom: 15,
                      child: Text(
                        '24',
                        style: OnlineTheme.textStyle(
                            weight: 5, color: OnlineTheme.yellow),
                      )),
                  Positioned(
                      left: 100,
                      top: 4,
                      child: Text(
                        'Mandag',
                        style: OnlineTheme.textStyle(weight: 3),
                      )),
                  Positioned(
                      left: 100,
                      bottom: 15,
                      child: Text(
                        '18:00-23:59',
                        style: OnlineTheme.textStyle(weight: 3, size: 12),
                      )),
                  Positioned(
                    right: 15,
                    top: 10,
                    child: SvgPicture.asset('assets/icons/calender_event.svg'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              width: 222,
              height: 60,
              child: Stack(
                children: [
                  Positioned(
                      left: 60,
                      top: 10,
                      child: Text(
                        'A4, Realfagsbygget',
                        style: OnlineTheme.textStyle(weight: 6, size: 20),
                      )),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: SvgPicture.asset('assets/icons/location_pin.svg'),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
         Padding(
        padding: horizontalPadding,
        child: Text(
          'Beskrivelse',
          style: OnlineTheme.textStyle(
              weight: 6, size: 20, color: OnlineTheme.orange10),
        ),),
        const SizedBox(height: 5),
        Padding(
          padding: horizontalPadding,
          child: Text(
            'Har du noen gang latt deg inspere av Appkoms sjuke sjekkereplikker. Ta turen til A4!...',
            style: OnlineTheme.textStyle(weight: 4, size: 15),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: horizontalPadding,
          child: Text(
            'Les mer',
            style: OnlineTheme.textStyle(
                weight: 4, size: 15, color: OnlineTheme.yellow),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  // Use Expanded widget for each button if you want them to fill the available horizontal space.
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8), // Add space between the buttons
                    child: ElevatedButton(
                      onPressed: () {
                        // Your code when 'Meld meg på' is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.green, // Text color
                      ),
                      child: const Text('Meld meg på'),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Your code when 'Se Påmeldte' is pressed
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                    ),
                    child: const Text('Se Påmeldte'),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 100),
      ],
    );
  }
}
