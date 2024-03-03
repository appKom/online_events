import 'package:flutter/material.dart';

import '/theme/theme.dart';

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 70,
              ),
              SizedBox(
                height: 160,
                child: Center(
                  child: Text(
                    name,
                    style: OnlineTheme.textStyle(color: OnlineTheme.gray0, weight: 5, size: 25),
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
