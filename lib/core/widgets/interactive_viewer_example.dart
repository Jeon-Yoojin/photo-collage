import 'package:flutter/material.dart';

class InteractiveViewerExample extends StatelessWidget {
  final Widget child;
  const InteractiveViewerExample({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: InteractiveViewer(
            constrained: false,
            transformationController: TransformationController(),
            minScale: 0.1,
            maxScale: 2.0,
            child: child));
  }
}

