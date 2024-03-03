import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';

import '../../../theme/theme.dart';

class CustomCard extends StatelessWidget {
  final String name;

  const CustomCard({super.key, required this.name});

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
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                    color: OnlineTheme.hundredPrimaryTextColor,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Avenir',
                    fontSize: 50),
                textAlign: TextAlign.left,
              ),
              Center(
                child: Text(
                  "Solar System",
                  style: TextStyle(
                      color: OnlineTheme.hundredPrimaryTextColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Avenir',
                      fontSize: 28),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Know More",
                    style: TextStyle(
                        color: OnlineTheme.hundredSecondaryTextColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Avenir',
                        fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Icon(
                      Ionicons.arrow_forward,
                      color: OnlineTheme.hundredSecondaryTextColor,
                      size: 20,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
