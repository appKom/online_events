import 'package:flutter/material.dart';

class EventCardButtons extends StatefulWidget {
  @override
  _EventCardButtonsState createState() => _EventCardButtonsState();
}

class _EventCardButtonsState extends State<EventCardButtons> {
  bool isRegistered = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        isRegistered
            ? ElevatedButton(
          onPressed: () {
            // Implement the "Vis billett" action here
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
          child: Text('Vis billett'),
        )
            : ElevatedButton(
          onPressed: () {
            // Implement the "Meld meg på" action here
            setState(() {
              isRegistered = true;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          child: Text('Meld meg på'),
        ),
        ElevatedButton(
          onPressed: () {
            // Implement the "Se påmeldte" or "Meld av" action here
            setState(() {
              isRegistered = false; // Reset to the initial state
            });
          },
          style: ElevatedButton.styleFrom(
            primary: isRegistered ? Colors.red : Colors.blue,
          ),
          child: Text(isRegistered ? 'Meld av' : 'Se påmeldte'),
        ),
      ],
    );
  }
}
