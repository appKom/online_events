import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/models/list_event.dart';
import '/upcoming_card.dart';
import '/theme.dart';

class Bedpress extends StatelessWidget {
  const Bedpress({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    return const SizedBox(
      height: 300,
      child: Column(
        children: [
          SizedBox(height: 50, child: Text('Bedriftpresentasjoner')),
          Expanded(
            child: Row(
              
            ),
          ),
        ],
      ),
    );
  }
}

// class UpcomingBedpress extends StatelessWidget {}
