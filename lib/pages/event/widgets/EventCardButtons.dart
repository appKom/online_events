import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/components/separator.dart';
import 'package:online_events/main.dart';
import 'package:online_events/pages/event/qr_code.dart';
import 'package:online_events/pages/event/show_participants.dart';
import 'package:online_events/services/app_navigator.dart';
import 'package:online_events/theme/theme.dart';

class EventCardButtons extends StatefulWidget {
  const EventCardButtons({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventCardButtonsState createState() => _EventCardButtonsState();
}

class _EventCardButtonsState extends State<EventCardButtons> {
  bool isRegistered = false;

  @override
  Widget build(BuildContext context) {
    double buttonHeight = 50;

BoxDecoration boxDecoration(bool isForSePameldte, bool isForVisBillett, bool isRegistered) {
    return BoxDecoration(
      gradient: isForSePameldte
          ? LinearGradient(
              colors: [Colors.blue[300]!, Colors.blue[800]!], // Blue gradient for "Se Påmeldte"
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
          : isForVisBillett
              ? const LinearGradient(
                  colors: [Color.fromARGB(255, 130, 13, 173), Color.fromARGB(255, 251, 45, 251)], // Yellow gradient for "Vis Billett"
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : LinearGradient(
                  colors: isRegistered 
                          ? [Colors.orange[300]!, Colors.red[800]!] // Red gradient for "Meld av"
                          : [Colors.green[300]!, Colors.green[800]!], // Green gradient for "Meld meg på"
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
      borderRadius: BorderRadius.circular(8),
    );
  }

    // Button style
    if (loggedIn) {
      return Row(
        children: [
          isRegistered
              ? Flexible(
                  child: AnimatedButton(
                    onPressed: () {
                      // Implement the "Vis billett" action here
                      AppNavigator.navigateToRoute(
                        QRCode(
                          name: 'Fredrik Hansteen',
                        ),
                        additive: true,
                      );
                    },
                    // style: buttonStyle.copyWith(
                    //   backgroundColor: MaterialStateProperty.all(Colors.blue),
                    // ),

                    child: Container(
                      alignment: Alignment.center,
                      height: buttonHeight,
                      decoration: boxDecoration(false,true, isRegistered),
                      child:
                          Text('Vis billett', style: OnlineTheme.textStyle()),
                    ),
                  ),
                )
              : const SizedBox(
                  width: 10,
                ),
          // onPressed: () {
          //     setState(() {
          //       isRegistered = !isRegistered; // Toggle isRegistered state
          //     });
          //   },

          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: AnimatedButton(
              onPressed: () {
                setState(() {
                  isRegistered = !isRegistered; // Toggle isRegistered state
                });
              },
              child: Container(
                alignment: Alignment.center,
                height: buttonHeight,
                decoration: boxDecoration(false, false, isRegistered ),
                child: Text(
                  isRegistered ? 'Meld av' : 'Meld meg på',
                  style: OnlineTheme.textStyle(),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),

          Flexible(
            child: AnimatedButton(
              onPressed: () {
                // Navigate to ShowParticipants regardless of isRegistered state
                AppNavigator.navigateToRoute(
                  ShowParticipants(),
                  additive: true,
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                decoration: boxDecoration(true, false, false), // Use false for blue gradient
                child: Text('Se Påmeldte', style: OnlineTheme.textStyle()),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const Separator(margin: 1),
          Center(
            child: Text(
              'Du må være logget inn for å se din status.',
              style: OnlineTheme.textStyle(),
            ),
          ),
        ],
      );
    }
  }
}
