import 'package:flutter/material.dart';

import '/theme/theme.dart';

class EventLocation extends StatelessWidget {
  const EventLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 20),
      height: 65,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: OnlineTheme.blueBg, // Blue background for the icon
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.location_on_outlined,
                  size: 20, // Adjust the size of the icon as needed
                  color: OnlineTheme.current.fg,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Portugal, Ericeria',
                style: OnlineTheme.textStyle(size: 16, height: 1.5, color: OnlineTheme.gray9, weight: 4),
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
