import 'package:flutter/material.dart';

import '/theme/theme.dart';

class CustomCard extends StatelessWidget {
  final String name;
  final int index;

  const CustomCard({super.key, required this.name, required this.index});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: Text(
                    name,
                    style: OnlineTheme.textStyle(
                      color: OnlineTheme.gray0,
                      weight: 5,
                      size: 25,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      index.toString(),
                      style: OnlineTheme.textStyle(
                        color: OnlineTheme.purple1,
                        size: 20,
                        weight: 6,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
