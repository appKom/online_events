import 'package:flutter/material.dart';

import '/theme/theme.dart';

class BitsCard extends StatelessWidget {
  final String header;
  final String body;
  final int position;
  final int length;

  const BitsCard(
      {super.key,
      required this.body,
      required this.position,
      required this.header,
      required this.length});

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
                height: 20,
              ),
              Center(
                child: Text(
                  header,
                  style: OnlineTheme.textStyle(
                      color: OnlineTheme.gray0, weight: 7, size: 25),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 160,
                child: Center(
                  child: Text(
                    body,
                    style: OnlineTheme.textStyle(
                        color: OnlineTheme.gray0, weight: 5, size: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    length.toString(),
                    style: OnlineTheme.textStyle(
                      color: OnlineTheme.purple1,
                      weight: 6,
                      size: 24,
                    ),
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
