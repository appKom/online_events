import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../core/client/client.dart';
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

  Widget content() {
    return Column(
      children: [
        MarkdownBody(
          data: _getText(),
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: OnlineTheme.textStyle(),
            h1: const TextStyle(color: OnlineTheme.white),
            h2: const TextStyle(color: OnlineTheme.white),
            h3: const TextStyle(color: OnlineTheme.white),
            h4: const TextStyle(color: OnlineTheme.white),
            h5: const TextStyle(color: OnlineTheme.white),
            h6: const TextStyle(color: OnlineTheme.white),
          ),
          onTapLink: (text, href, title) {
            if (href == null) return;
            Client.launchInBrowser(href);
          },
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

class InAppWebViewPage extends StatelessWidget {
  final String url;
  const InAppWebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
      ),
    );
  }
}
