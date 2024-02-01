import 'package:flutter/material.dart';
import 'dart:math';

import 'package:online_events/components/online_scaffold.dart';

class RoulettePage extends OnlinePage {
  const RoulettePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: RouletteWheel(),
      ),
    );
  }

  @override
  Widget content(BuildContext context) {
    // TODO: implement content
    throw UnimplementedError();
  }
}

class RouletteWheel extends StatefulWidget {
  const RouletteWheel({super.key});

  @override
  _RouletteWheelState createState() => _RouletteWheelState();
}

class _RouletteWheelState extends State<RouletteWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentRotation = 0;
  double _startRotation = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    _controller.addListener(() => setState(() {}));
  }

  void _updateRotation(Offset details) {
    setState(() {
      _currentRotation = (_startRotation + details.direction) % (2 * pi);
    });
  }

  void _onPanStart(DragStartDetails details) {
    _startRotation = _currentRotation;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updateRotation(details.delta);
  }

  void _onPanEnd(DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond.distance / 1000;
    final double endRotation = (_currentRotation + velocity) % (2 * pi);
    _animation =
        Tween<double>(begin: _currentRotation, end: endRotation).animate(
      CurvedAnimation(parent: _controller, curve: Curves.decelerate),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        size: const Size(400.0, 400.0),
        painter: CirclePainter(
            _controller.isAnimating ? _animation.value : _currentRotation),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final double rotation;
  CirclePainter(this.rotation);

  final List<Color> colors = [
    Colors.green, // For zero
    Colors.red,
    Colors.black,
  ];

  final challenges = [
    {
      "title": "Waterfall",
      "description": "Alle drikker help til de til venstre slutter"
    },
    {
      "title": "6 Minutes",
      "description": "Finn en spotify playlist og folk må gjette sangene"
    },
        {
      "title": "Waterfall",
      "description": "Alle drikker help til de til venstre slutter"
    },
    {
      "title": "6 Minutes",
      "description": "Finn en spotify playlist og folk må gjette sangene"
    },
        {
      "title": "Waterfall",
      "description": "Alle drikker help til de til venstre slutter"
    },
    {
      "title": "6 Minutes",
      "description": "Finn en spotify playlist og folk må gjette sangene"
    },
        {
      "title": "Waterfall",
      "description": "Alle drikker help til de til venstre slutter"
    },
    {
      "title": "6 Minutes",
      "description": "Finn en spotify playlist og folk må gjette sangene"
    },
        {
      "title": "Waterfall",
      "description": "Alle drikker help til de til venstre slutter"
    },
    {
      "title": "6 Minutes",
      "description": "Finn en spotify playlist og folk må gjette sangene"
    },
    // ... other challenges
  ];

  int get totalSegments => challenges.length;
  static const double borderSize = 2; // Width of the white border

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;

    final double sweepAngle = (2 * pi) / totalSegments;
    final double textRadius = radius - 20;

    for (int i = 0; i < totalSegments; i++) {
      final Paint paint = Paint()
        ..color = getColorForSegment(i)
        ..style = PaintingStyle.fill;

      final double startAngle = i * sweepAngle - pi / 2 + rotation;

      final path = Path()
        ..moveTo(centerX, centerY)
        ..arcTo(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      canvas.drawPath(path, paint);

      final Paint borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderSize;

      final double borderStartAngle = startAngle + sweepAngle;
      final pathBorder = Path()
        ..arcTo(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          borderStartAngle,
          borderSize / radius,
          false,
        );

      canvas.drawPath(pathBorder, borderPaint);
    }

        for (int i = 0; i < totalSegments; i++) {
      // Calculate the angle for the text
      final double textAngle =
          i * sweepAngle + sweepAngle / 2 - pi / 2 + rotation;

      // Calculate the position for the text
      final Offset textPosition = Offset(
        centerX + textRadius * cos(textAngle),
        centerY + textRadius * sin(textAngle),
      );

      // Define the text style
      TextSpan span = TextSpan(
          style: TextStyle(color: getTextColorForSegment(i), fontSize: 12),
          text: challenges[i]["title"]);
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();

      // Draw the text
      tp.paint(canvas, textPosition - Offset(tp.width / 2, tp.height / 2));
    }
  }

  Color getColorForSegment(int segment) {
    if ((segment == 200) || (segment == 19)) return colors[0];
    return colors[(segment % 2) + 1];
  }

  Color getTextColorForSegment(int segment) {
    return colors[((segment + 1) % 2) + 1];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
