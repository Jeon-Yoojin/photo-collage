import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double width;

  Stroke({required this.points, required this.color, required this.width});
}

class DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;

  const DrawingPainter({
    required this.strokes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      if (stroke.points.length < 2) continue;

      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.butt
        ..strokeJoin = StrokeJoin.round;

      final path = Path();
      path.moveTo(stroke.points[0].dx, stroke.points[0].dy);

      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}

class DrawingLayer extends StatefulWidget {
  final Color drawColor;
  final double strokeWidth;
  final bool isEnabled;
  final List<Stroke> strokes;
  final Function(List<Stroke>) onStrokesChanged;

  const DrawingLayer(
      {super.key,
      required this.drawColor,
      required this.strokeWidth,
      required this.strokes,
      required this.onStrokesChanged,
      this.isEnabled = true});

  @override
  State<DrawingLayer> createState() => _DrawingLayerState();
}

class _DrawingLayerState extends State<DrawingLayer> {
  List<Offset> currentPoints = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.isEnabled
          ? HitTestBehavior.translucent
          : HitTestBehavior.deferToChild,
      onPanStart: (details) {
        if (!widget.isEnabled) return;
        setState(() {
          currentPoints = [details.localPosition];
          final newStroke = Stroke(
              points: List.from(currentPoints),
              color: widget.drawColor,
              width: widget.strokeWidth);
          widget.onStrokesChanged([...widget.strokes, newStroke]);
        });
      },
      onPanUpdate: (details) {
        if (!widget.isEnabled) return;
        setState(() {
          currentPoints.add(details.localPosition);

          if (widget.strokes.isNotEmpty) {
            final updatedStrokes = [...widget.strokes];
            updatedStrokes[updatedStrokes.length - 1] = Stroke(
                points: List.from(currentPoints),
                color: widget.drawColor,
                width: widget.strokeWidth);
            widget.onStrokesChanged(updatedStrokes);
          }
        });
      },
      onPanEnd: (details) {
        if (!widget.isEnabled) return;
        setState(() {
          currentPoints = [];
        });
      },
      child: IgnorePointer(
        ignoring: !widget.isEnabled,
        child: CustomPaint(
            painter: DrawingPainter(
              strokes: widget.strokes,
            ),
            size: Size.infinite),
      ),
    );
  }
}
