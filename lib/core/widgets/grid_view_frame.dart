import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'interactive_viewer_example.dart';

class GridViewFrame extends StatelessWidget {
  final List<XFile> images;
  const GridViewFrame({required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return InteractiveViewerExample(
          child: Image.file(
            File(images[index].path),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}

