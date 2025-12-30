import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
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
      if (stroke.length < 2) continue;

      final path = Path();
      path.moveTo(stroke[0].dx, stroke[0].dy);

      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
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

  const DrawingLayer(
      {super.key,
      required this.drawColor,
      required this.strokeWidth,
      this.isEnabled = true});

  @override
  State<DrawingLayer> createState() => _DrawingLayerState();
}

class _DrawingLayerState extends State<DrawingLayer> {
  List<List<Offset>> strokes = [];
  List<Offset> currentStroke = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.isEnabled
          ? HitTestBehavior.translucent
          : HitTestBehavior.deferToChild,
      onPanStart: (details) {
        if (!widget.isEnabled) return;
        setState(() {
          currentStroke.add(details.localPosition);
          strokes.add(currentStroke);
        });
      },
      onPanUpdate: (details) {
        setState(() {
          if (!widget.isEnabled) return;
          currentStroke.add(details.localPosition);
        });
      },
      onPanEnd: (details) {
        setState(() {
          if (!widget.isEnabled) return;
          currentStroke = [];
        });
      },
      child: CustomPaint(
          painter: DrawingPainter(
              strokes: strokes,
              drawColor: widget.drawColor,
              strokeWidth: widget.strokeWidth),
          size: Size.infinite),
    );
  }
}
