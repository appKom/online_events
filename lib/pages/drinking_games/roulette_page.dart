import 'package:flutter/material.dart';
import 'dart:math';
import 'package:online_events/components/online_scaffold.dart';

class RoulettePage extends StaticPage {
  const RoulettePage({super.key});

  @override
  Widget content(BuildContext context) {
    return const RouletteWheel();
  }
}

class RouletteWheel extends StatelessWidget {
  const RouletteWheel({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100.0, 100.0),
      painter: CirclePainter(),
    );
  }
}

class CirclePainter extends CustomPainter {
  final List<Color> colors = [
    Colors.green, // For 0 and 00
    Colors.red,
    Colors.black,
  ];

  // European roulette has 37 segments (1 green, 18 red, 18 black)
  static const int totalSegments = 38;
  
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2;
    
    // We will draw in radians, not degrees
    const double sweepAngle = (2 * pi) / totalSegments;
    
    for (int i = 0; i < totalSegments; i++) {
      final Paint paint = Paint()
        ..color = getColorForSegment(i) // We'll define this function below
        ..style = PaintingStyle.fill;
      
      final double startAngle = i * sweepAngle - pi / 2; // Adjusting by -pi/2 to start from the top
      
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
    }
  }
  
  Color getColorForSegment(int segment) {
    // Assuming segment 0 is green, and then alternate colors, adjust as needed
    if ((segment == 0) || (segment == 19)) return colors[0]; // Green for zero
    return colors[(segment % 2) + 1];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
