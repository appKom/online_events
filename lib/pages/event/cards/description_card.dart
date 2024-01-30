import 'package:flutter/material.dart';

import '/pages/event/cards/event_card.dart';
import '/theme/theme.dart';

class EventDescriptionCard extends StatefulWidget {
  const EventDescriptionCard({
    super.key,
    required this.description,
    required this.organizer,
  });

  final String description;
  final String organizer;

  @override
  DescriptionCardState createState() => DescriptionCardState();
}

class DescriptionCardState extends State<EventDescriptionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: OnlineCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            const SizedBox(height: 16),
            content(),
          ],
        ),
      ),
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
          color: OnlineTheme.white,
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
              widget.organizer,
              style: OnlineTheme.textStyle(),
            )
          ],
        ),
      ],
    );
  }
}
