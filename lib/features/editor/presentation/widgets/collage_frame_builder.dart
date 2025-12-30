import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'package:recall_scanner/features/editor/presentation/widgets/drawing_layer.dart';
import 'dart:io';
import 'package:recall_scanner/models/sticker.dart';

class CollageFrameBuilder extends StatefulWidget {
  final TemplateModel template;
  final Map<int, XFile> imageMap;
  final Map<int, Sticker> stickerMap;

  final bool isDrawingMode;
  final Color drawColor;
  final double strokeWidth;

  final Function(int cellId, XFile image)? onImageSelected;
  final Function(Sticker sticker) onStickerMoved;
  final Function(Sticker sticker) onStickerUpdated;

  const CollageFrameBuilder({
    required this.template,
    this.imageMap = const {},
    this.stickerMap = const {},
    this.isDrawingMode = false,
    this.drawColor = Colors.black,
    this.strokeWidth = 2.0,
    this.onImageSelected,
    required this.onStickerMoved,
    required this.onStickerUpdated,
    super.key,
  });

  @override
  State<CollageFrameBuilder> createState() => _CollageFrameBuilderState();
}

class _CollageFrameBuilderState extends State<CollageFrameBuilder> {
  final Map<int, double> _initialWidths = {};
  final Map<int, double> _initialHeights = {};
  final Map<int, double> _initialRotations = {};
  final Map<int, Offset> _initialFocalPoints = {};
  final Map<int, Offset> _initialStickerCenters = {};

  void _getImages(int cellId) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
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
        children: [
          ...template.cells.map((cell) {
            final imageFile = widget.imageMap[cell.id];

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
          }),
          ...widget.stickerMap.values.map((sticker) {
            Widget stickerWidget;

            stickerWidget = GestureDetector(
                onScaleStart: (details) {
                  setState(() {
                    _initialWidths[sticker.id] = sticker.width;
                    _initialHeights[sticker.id] = sticker.height;
                    _initialRotations[sticker.id] = sticker.rotation;
                    _initialFocalPoints[sticker.id] = details.focalPoint;

                    _initialStickerCenters[sticker.id] = Offset(
                      sticker.x + sticker.width / 2,
                      sticker.y + sticker.height / 2,
                    );
                  });
                },
                onScaleUpdate: (details) {
                  final initialWidth = _initialWidths[sticker.id];
                  final initialHeight = _initialHeights[sticker.id];
                  final initialRotation = _initialRotations[sticker.id];
                  final initialFocalPoint = _initialFocalPoints[sticker.id];
                  final initialStickerCenter =
                      _initialStickerCenters[sticker.id];

                  if (initialWidth == null ||
                      initialHeight == null ||
                      initialRotation == null ||
                      initialFocalPoint == null ||
                      initialStickerCenter == null) {
                    return;
                  }

                  if (details.pointerCount == 2) {
                    setState(() {
                      final newWidth = initialWidth * details.scale;
                      final newHeight = initialHeight * details.scale;

                      final minSize = 30.0;
                      final maxSize = 400.0;
                      // 최대, 최소값 범위 제한
                      sticker.width = newWidth.clamp(minSize, maxSize);
                      sticker.height = newHeight.clamp(minSize, maxSize);

                      final rotationDelta =
                          details.rotation * (180 / 3.14159265359);
                      sticker.rotation = initialRotation + rotationDelta;

                      final focalDelta = details.focalPoint - initialFocalPoint;

                      sticker.x = initialStickerCenter.dx -
                          sticker.width / 2 +
                          focalDelta.dx;
                      sticker.y = initialStickerCenter.dy -
                          sticker.height / 2 +
                          focalDelta.dy;
                    });
                    widget.onStickerUpdated(sticker);
                  } else if (details.pointerCount == 1) {
                    setState(() {
                      sticker.x += details.focalPointDelta.dx;
                      sticker.y += details.focalPointDelta.dy;
                    });
                    widget.onStickerMoved(sticker);
                  }
                },
                onScaleEnd: (details) {
                  setState(() {
                    _initialWidths.remove(sticker.id);
                    _initialHeights.remove(sticker.id);
                    _initialRotations.remove(sticker.id);
                    _initialFocalPoints.remove(sticker.id);
                    _initialStickerCenters.remove(sticker.id);
                  });
                },
                child: Image.network(
                  sticker.imgPath,
                  fit: BoxFit.contain,
                ));

            if (sticker.rotation != 0) {
              stickerWidget = Transform.rotate(
                angle: sticker.rotation * (3.14159265359 / 180),
                child: stickerWidget,
              );
            }

            return Positioned(
              left: sticker.x,
              top: sticker.y,
              width: sticker.width,
              height: sticker.height,
              child: stickerWidget,
            );
          }),
          if (widget.isDrawingMode)
            Positioned.fill(
                child: DrawingLayer(
                    drawColor: widget.drawColor,
                    strokeWidth: widget.strokeWidth)),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildTemplate(widget.template);
  }
}
