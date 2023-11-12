import 'package:flutter/material.dart';
import 'package:online_events/components/animated_button.dart';
import 'package:online_events/theme/theme.dart';

class EventCardButtons extends StatefulWidget {
  @override
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
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: isRegistered ? Colors.red : Colors.green,
      fixedSize: Size(buttonWidth, buttonHeight),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        isRegistered
            ? AnimatedButton(
                onPressed: () {
                  // Implement the "Vis billett" action here
                },
                // style: buttonStyle.copyWith(
                //   backgroundColor: MaterialStateProperty.all(Colors.blue),
                // ),

                child: Container(
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      color: isRegistered ? Colors.blue : OnlineTheme.green1,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text('Vis billett', style: OnlineTheme.textStyle(),),
                  ),
              )
            : Expanded(
              child: AnimatedButton(
                  onPressed: () {
                    // Implement the "Meld meg på" action here
                    setState(() {
                      isRegistered = true;
                    });
                  },
                  child: Container(
                    height: buttonHeight,
                    width: buttonWidth,
                    decoration: BoxDecoration(
                      color: OnlineTheme.green1,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text('Meld meg på', style: OnlineTheme.textStyle(),),
                  ),
                ),
            ),
        AnimatedButton(
          onPressed: () {
            // Implement the "Se påmeldte" or "Meld av" action here
            setState(() {
              isRegistered = false; // Reset to the initial state
            });
          },
          child: Container(
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
