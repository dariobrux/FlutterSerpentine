import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_serpentine/direction.dart';

class Serpentine extends StatelessWidget{
  final Direction direction;
  final double arcRadius;
  final double strokeWidth;
  final List<Color> colors;

  Serpentine(this.direction, this.arcRadius, this.strokeWidth, this.colors);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SerpentinePainter(direction, arcRadius, strokeWidth, colors),
    );
  }
}

class SerpentinePainter extends CustomPainter {
  final Direction direction;
  final double arcRadius;
  final double strokeWidth;
  final List<Color> colors;

  SerpentinePainter(this.direction, this.arcRadius, this.strokeWidth, this.colors);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    Path path;

    var rect = Offset.zero & size;

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = this.strokeWidth;

    var arcRadius = this.arcRadius;

    switch (direction) {
      case Direction.verticalLeft:
        paint.shader = _getVerticalLeftShader(rect);
        path = _getVerticalLeftPath(size, arcRadius);
        break;
      case Direction.verticalRight:
        paint.shader = _getVerticalRightShader(rect);
        path = _getVerticalRightPath(size, arcRadius);
        break;
      case Direction.vertical:
        paint.shader = _getVerticalShader(rect);
        path = _getVerticalPath(size);
        break;
    }

    if (direction == Direction.verticalLeft) {}

    canvas.drawPath(path, paint);
  }

  Shader _getVerticalLeftShader(Rect rect){
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: this.colors,
    ).createShader(rect);
  }

  Shader _getVerticalRightShader(Rect rect){
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: this.colors,
    ).createShader(rect);
  }

  Shader _getVerticalShader(Rect rect){
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: this.colors,
    ).createShader(rect);
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

  Path _getVerticalPath(ui.Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);

    // Draw the line till the end in vertical
    path.lineTo(size.width / 2, size.height);

    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}