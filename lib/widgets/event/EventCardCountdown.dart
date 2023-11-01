import 'package:flutter/material.dart';

class EventCardCountdown extends StatelessWidget {
  const EventCardCountdown({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNumberColumn("12", "Dager"),
            buildNumberColumn("4", "Timer"),
            buildNumberColumn("8", "Minutter"),
            buildNumberColumn("6", "Sekunder"),
          ],
        ),
      ),
    );
  }

  Widget buildNumberColumn(String number, String label) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 20, // Adjust the size of the text as needed
                color: Colors.white, // Text color
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14, // Adjust the size of the label as needed
              color: Colors.white, // Text color
            ),
          ),
        ),
        SizedBox(height: 4), // Add a small amount of space between the number and label
      ],
    );
  }
}
