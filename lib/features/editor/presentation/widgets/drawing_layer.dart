import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double width;

  Stroke({required this.points, required this.color, required this.width});
}

class DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;
  final Color drawColor;
  final double strokeWidth;

  const DrawingPainter({
    required this.strokes,
    required this.drawColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = drawColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round;

    for (final stroke in strokes) {
      if (stroke.points.length < 2) continue;

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
  final Function(List<List<Offset>>) onStrokesChanged;

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
  Stroke currentStroke =
      Stroke(points: [], color: widget.drawColor, width: widget.strokeWidth);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.isEnabled
          ? HitTestBehavior.translucent
          : HitTestBehavior.deferToChild,
      onPanStart: (details) {
        if (!widget.isEnabled) return;
        setState(() {
          currentStroke.points.add(details.localPosition);
          widget.onStrokesChanged([...widget.strokes, currentStroke]);
        });
      },
      onPanUpdate: (details) {
        if (!widget.isEnabled) return;
        setState(() {
          currentStroke.points.add(details.localPosition);

          if (widget.strokes.isNotEmpty) {
            final updatedStrokes = [...widget.strokes];
            updatedStrokes[updatedStrokes.length - 1] = Stroke(
                points: List.from(currentStroke.points),
                color: currentStroke.color,
                width: currentStroke.width);
            widget.onStrokesChanged(updatedStrokes);
          }
        });
      },
      onPanEnd: (details) {
        setState(() {
          if (!widget.isEnabled) return;
          currentStroke = Stroke(
              points: [], color: widget.drawColor, width: widget.strokeWidth);
        });
      },
      child: IgnorePointer(
        ignoring: !widget.isEnabled,
        child: CustomPaint(
            painter: DrawingPainter(
              strokes: [currentStroke, ...widget.strokes],
              drawColor: widget.drawColor,
              strokeWidth: widget.strokeWidth,
            ),
            size: Size.infinite),
      ),
    );
  }
}
