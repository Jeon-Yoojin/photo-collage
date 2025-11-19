import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../models/collage_template.dart';
import '../../../../../models/collage_row.dart';

class CollageFrameBuilder extends StatelessWidget {
  final CollageTemplate template;
  final List<XFile> images;

  const CollageFrameBuilder(
      {required this.template, required this.images, super.key});

  @override
  Widget build(BuildContext context) {
    int imgIndex = 0;

    return Column(
      children: template.rows.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: _mapAlignment(row),
            children: row.cells.map((cell) {
              Widget child;
              if (imgIndex < images.length) {
                final image = images[imgIndex++];
                child = Image.file(
                  File(image.path),
                  fit: BoxFit.cover,
                );
              } else {
                imgIndex++;
                child = Container(
                  color: Colors.black,
                  child: Center(
                    child: Icon(Icons.image, color: Colors.white, size: 40),
                  ),
                );
              }
              if (cell.flex > 0) {
                return Expanded(flex: cell.flex, child: child);
              } else {
                return SizedBox(width: cell.width, child: child);
              }
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  MainAxisAlignment _mapAlignment(CollageRow row) {
    if (row.cells.isEmpty) return MainAxisAlignment.start;
    final align = row.cells.first.align;
    switch (align) {
      case 'center':
        return MainAxisAlignment.center;
      case 'right':
        return MainAxisAlignment.end;
      default:
        return MainAxisAlignment.start;
    }
  }
}
