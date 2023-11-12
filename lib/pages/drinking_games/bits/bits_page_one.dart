import 'package:flutter/material.dart';
import 'package:online_events/components/online_header.dart';
import 'package:online_events/components/online_scaffold.dart';
import 'package:online_events/theme/theme.dart';

class BitsPageOne extends ScrollablePage {
  const BitsPageOne({super.key});

  @override
  Widget? header(BuildContext context) {
    return OnlineHeader();
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding +
        const EdgeInsets.symmetric(horizontal: 25);

    return Container(
      color: OnlineTheme.pink1,
      child: Padding(
        padding: EdgeInsets.only(left: padding.left, right: padding.right),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: OnlineHeader.height(context) + 40),
              const Text(
                'Noe, Noe',
                style: OnlineTheme.eventHeader,
              ),
              const SizedBox(height: 20),
              const ClipRRect(child: SizedBox(height: 120)),
              const Positioned(
                child: Text(
                  'Noe som rimer',
                  style: OnlineTheme.eventListHeader,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget content(BuildContext context) {
    // Properly implement the content method or make sure it's not called if not needed.
    return Container(); // Return an empty Container or actual content if available
  }
}
