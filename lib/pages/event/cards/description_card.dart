import 'package:flutter/material.dart';

import '/pages/event/cards/event_card.dart';
import '/theme/theme.dart';

class EventDescriptionCard extends StatefulWidget {
  const EventDescriptionCard({
    super.key,
    required this.description,
    required this.organizer,
    required this.ingress,
  });

  final String description;
  final String organizer;
  final String ingress;

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
        style: OnlineTheme.header(),
      ),
    );
  }

  String descriptionContent() {
    return '${widget.ingress}\n\n${widget.description}';
  }

  String _getText() {
    if (_isExpanded) return descriptionContent();
    if (descriptionContent().length <= 100) return descriptionContent();

    return '${descriptionContent().substring(0, 100)}...';
  }

  /// Card Content
  Widget content() {
    return Column(
      children: [
        Text(
          _getText(),
          style: OnlineTheme.textStyle(),
        ),
        const SizedBox(height: 10),
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
