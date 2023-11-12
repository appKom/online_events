import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
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
    // Define a fixed size for the buttons
     // Use MediaQuery to get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the button width based on screen size
    double buttonWidth = screenWidth * 0.3; // e.g., 30% of the screen width

    // Define the height of the buttons
    double buttonHeight = 50; // Fixed height

    // Button style

    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        isRegistered
            ? AnimatedButton(
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
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      color: isRegistered ? Colors.blue : OnlineTheme.green5,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text('Vis billett', style: OnlineTheme.textStyle(),),
                  ),
              ):
              
             Expanded(
              child: AnimatedButton(
                  onPressed: () {
                    // Implement the "Meld meg på" action here
                    setState(() {
                      isRegistered = true;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      color: OnlineTheme.green5,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text('Meld meg på', style: OnlineTheme.textStyle(),),
                  ),
                ),
            ),
            const SizedBox(width: 15,),
        AnimatedButton(
          onPressed: () {
            if (isRegistered) {
              setState(() {
                isRegistered = false; // Reset to the initial state
              });
            } else {
              // Open the ShowParticipants widget
              AppNavigator.navigateToRoute(
                  ShowParticipants(),
                  additive: true,
                );
            }
          },
          child: Container(
            alignment: Alignment.center,
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      color: isRegistered ? Colors.red : Colors.blue,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(isRegistered ? 'Meld av' : 'Se påmeldte', style: OnlineTheme.textStyle(),),
                  ),
          // style: buttonStyle.copyWith(
          //   backgroundColor: MaterialStateProperty.all(
          //       isRegistered ? Colors.red : Colors.blue),
          // ),
          // child: Text(isRegistered ? 'Meld av' : 'Se påmeldte'),
        ),
      ],
    );
  }
}
