import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_serpentine/direction.dart';

class Serpentine extends CustomPainter {
  final Direction direction;
  final double arcRadius;
  final double strokeWidth;
  final List<Color> colors;

  Serpentine(this.direction, this.arcRadius, this.strokeWidth, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    Path path;

    var rect = Offset.zero & size;

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = this.strokeWidth;
    paint.shader = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: this.colors,
    ).createShader(rect);

    var arcRadius = this.arcRadius;

    switch (direction) {
      case Direction.verticalLeft:
        path = _getVerticalLeftPath(size, arcRadius);
        break;
      case Direction.verticalRight:
        path = _getVerticalRightPath(size, arcRadius);
        break;
    }

    if (direction == Direction.verticalLeft) {}

    canvas.drawPath(path, paint);

    canvas.drawPoints(ui.PointMode.points, [Offset(size.width / 2, size.height / 2)], paint);
  }

  Path _getVerticalLeftPath(ui.Size size, double arcRadius) {
    var path = Path();
    path.moveTo(size.width, 0);

    // Draw line till the middle height
    path.lineTo(size.width, (size.height * 0.5) - arcRadius);

    // Draw the right arc
    Rect rightArc = Rect.fromCircle(center: Offset(size.width - arcRadius, (size.height * 0.5) - arcRadius), radius: arcRadius);
    path.arcTo(rightArc, 0, pi / 2, false);

    // Draw the horizontal line
    path.lineTo(arcRadius, size.height * 0.5);

    // Draw the left arc
    Rect leftArc = Rect.fromCircle(center: Offset(arcRadius, (size.height * 0.5) + arcRadius), radius: arcRadius);
    path.arcTo(leftArc, pi + pi / 2, -pi / 2, false);

    // Draw the line till the end in vertical
    path.lineTo(0, size.height);

    return path;
  }

  Path _getVerticalRightPath(ui.Size size, double arcRadius) {
    var path = Path();
    path.moveTo(0, 0);

    // Draw line till the middle height
    path.lineTo(0, (size.height * 0.5) - arcRadius);

    // Draw the right arc
    Rect rightArc = Rect.fromCircle(center: Offset(arcRadius, (size.height * 0.5) - arcRadius), radius: arcRadius);
    path.arcTo(rightArc, pi, -pi / 2, false);

    // Draw the horizontal line
    path.lineTo(size.width - arcRadius, (size.height * 0.5));

    // Draw the left arc
    Rect leftArc = Rect.fromCircle(center: Offset(size.width - arcRadius, (size.height * 0.5) + arcRadius), radius: arcRadius);
    path.arcTo(leftArc, -pi / 2, pi / 2, false);

    // Draw the line till the end in vertical
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class AppColors {
  static Color primaryColor = Colors.red;
}
