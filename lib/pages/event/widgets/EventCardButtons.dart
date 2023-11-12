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
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonHeight = 50;

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
                      decoration: BoxDecoration(
                          color:
                              isRegistered ? Colors.orange : OnlineTheme.green5,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'Vis billett',
                        style: OnlineTheme.textStyle(),
                      ),
                    ),
                  ),
                )
          :const SizedBox(
            width: 10,
          ),
            // onPressed: () {
            //     setState(() {
            //       isRegistered = !isRegistered; // Toggle isRegistered state
            //     });
            //   },


          const SizedBox(width: 10,),
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
                decoration: BoxDecoration(
                  color: isRegistered ? Colors.red : OnlineTheme.green5,
                  borderRadius: BorderRadius.circular(5),
                ),
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
              height: 50, // button height
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
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
          Text(
            'Du må være logget inn for å se din status.',
            style: OnlineTheme.textStyle(),
          ),
        ],
      );
    }
  }
}
