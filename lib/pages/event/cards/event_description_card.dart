import 'package:flutter/material.dart';

import '/components/animated_button.dart';
import '/pages/event/cards/event_card.dart';
import '/theme/theme.dart';

/// TODO: Standardize. This code is duplicated
class EventDescriptionCard extends StatefulWidget {
  const EventDescriptionCard({super.key, required this.description});

  final String description;

  @override
  // ignore: library_private_types_in_public_api
  _DescriptionCardState createState() => _DescriptionCardState();
}

class _DescriptionCardState extends State<EventDescriptionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      scale: 0.95,
      childBuilder: (context, hover, pointerDown) {
        return OnlineCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              const SizedBox(height: 16),
              content(),
            ],
          ),
        );
      },
    );
  }

  /// Card header
  Widget header() {
    return SizedBox(
      height: 32,
      child: Text(
        'Beskrivelse',
        style: OnlineTheme.textStyle(
          size: 20,
          weight: 7,
          color: OnlineTheme.yellow,
        ),
      ),
    );
  }

  String _getText() {
    if (_isExpanded) return widget.description;
    if (widget.description.length <= 100) return widget.description;

    return '${widget.description.substring(0, 100)}...';
  }

  /// Card Content
  Widget content() {
    return Column(
      children: [
        Text(
          _getText(),
          style: OnlineTheme.textStyle(),
        ),
        Text(
          _isExpanded ? 'Vis mindre' : 'Vis mer',
          style: OnlineTheme.textStyle(color: OnlineTheme.yellow),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Av Appkom <3',
              style: OnlineTheme.textStyle(),
            )
          ],
        ),
      ],
    );
  }
}
