import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'dart:io';
import 'package:recall_scanner/models/sticker.dart';

class CollageFrameBuilder extends StatefulWidget {
  final TemplateModel template;
  final Map<int, XFile> imageMap;
  final Map<int, Sticker> stickerMap;
  final Function(int cellId, XFile image)? onImageSelected;

  const CollageFrameBuilder({
    required this.template,
    this.imageMap = const {},
    this.stickerMap = const {},
    this.onImageSelected,
    super.key,
  });

  @override
  State<CollageFrameBuilder> createState() => _CollageFrameBuilderState();
}

class _CollageFrameBuilderState extends State<CollageFrameBuilder> {
  void _getImages(int cellId) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null && widget.onImageSelected != null) {
      widget.onImageSelected!(cellId, image);
    }
  }

  Widget _buildTemplate(TemplateModel template) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxW = constraints.maxWidth;
      final maxH = constraints.maxHeight;

      final canvasW = template.canvasWidth > 0 ? template.canvasWidth : maxW;
      final canvasH = template.canvasHeight > 0 ? template.canvasHeight : maxH;

      return Stack(
        fit: StackFit.expand,
        children: template.cells.map((cell) {
          final imageFile = widget.imageMap[cell.id];
          // final sticker = widget.stickerMap[]

          Widget cellWidget;
          if (imageFile != null) {
            cellWidget = Image.file(File(imageFile.path), fit: BoxFit.cover);
          } else {
            cellWidget = Container(
              color: Colors.grey[300],
              child: Center(
                child: Icon(Icons.image, color: Colors.grey[700], size: 36),
              ),
            );
          }

          cellWidget = GestureDetector(
            onTap: () => _getImages(cell.id),
            child: cellWidget,
          );

          if (cell.borderRadius > 0 || cell.rotation != 0) {
            cellWidget = Transform.rotate(
                angle: cell.rotation * (3.14159265359 / 180),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(cell.borderRadius),
                    child: cellWidget));
          }

          final relativeX = cell.x / canvasW;
          final relativeY = cell.y / canvasH;
          final relativeWidth = cell.width / canvasW;
          final relativeHeight = cell.height / canvasH;

          return Positioned(
            left: relativeX * maxW,
            top: relativeY * maxH,
            width: relativeWidth * maxW,
            height: relativeHeight * maxH,
            child: cellWidget,
          );
        }).toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildTemplate(widget.template);
  }
}
