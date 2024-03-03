import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';

import '../../../theme/theme.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final int position;

  const CustomCard({super.key, required this.name, required this.position});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(34.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              Container(
                height: 160,
                child: Center(
                  child: Text(
                    name,
                    style: const TextStyle(
                        color: OnlineTheme.hundredPrimaryTextColor,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Avenir',
                        fontSize: 28),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    position.toString(),
                    style: const TextStyle(
                        color: OnlineTheme.hundredSecondaryTextColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Avenir',
                        fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
