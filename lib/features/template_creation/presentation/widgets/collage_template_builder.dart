import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recall_scanner/features/template_creation/presentation/pages/add_template_page.dart';

class CollageTemplateBuilder extends StatelessWidget {
  final CollageTemplateNew template;
  final Map<String, XFile> imageMap;

  const CollageTemplateBuilder(
      {required this.template, this.imageMap = const {}, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxW = constraints.maxWidth;
      final maxH = constraints.maxHeight;

      return Stack(
        children: template.cells.map((cell) {
          final imageFile = imageMap[cell.id];

          Widget cellWidget = imageFile != null
              ? Image.file(File(imageFile.path), fit: BoxFit.cover)
              : Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(Icons.image, color: Colors.grey[700], size: 36),
                  ),
                );

          if (cell.borderRadius > 0 || cell.rotation != 0) {
            cellWidget = Transform.rotate(
                angle: cell.rotation * (3.14159265359 / 180),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(cell.borderRadius),
                    child: cellWidget));
          }

          return Positioned(
            left: cell.x * maxW,
            top: cell.y * maxH,
            width: cell.width * maxW,
            height: cell.height * maxH,
            child: cellWidget,
          );
        }).toList(),
      );
    });
  }
}
