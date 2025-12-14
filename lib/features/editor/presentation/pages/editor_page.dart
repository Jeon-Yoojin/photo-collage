import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'package:recall_scanner/extensions/layout_extension.dart';
import '../widgets/collage_frame_builder.dart';

class EditPhotoPage extends StatefulWidget {
  final TemplateModel template;
  const EditPhotoPage({super.key, required this.template});

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  final repaintBoundary = GlobalKey();
  Map<int, XFile> imageMap = <int, XFile>{};

  Future<ui.Image> _cropAndResizeImage(
    ui.Image image,
    double targetAspectRatio,
    double currentAspectRatio,
  ) async {
    int cropWidth = image.width;
    int cropHeight = image.height;
    double cropX = 0;
    double cropY = 0;

    if (currentAspectRatio > targetAspectRatio) {
      cropWidth = (image.height * targetAspectRatio).toInt();
      cropX = (image.width - cropWidth) / 2;
    } else {
      cropHeight = (image.width / targetAspectRatio).toInt();
      cropY = (image.height - cropHeight) / 2;
    }

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final paint = ui.Paint()..filterQuality = ui.FilterQuality.high;

    canvas.drawImageRect(
      image,
      ui.Rect.fromLTWH(
          cropX, cropY, cropWidth.toDouble(), cropHeight.toDouble()),
      ui.Rect.fromLTWH(0, 0, cropWidth.toDouble(), cropHeight.toDouble()),
      paint,
    );

    final picture = recorder.endRecording();
    return await picture.toImage(cropWidth, cropHeight);
  }

  Future<void> _saveImage() async {
    try {
      final shouldProceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('권한 필요'),
          content: Text('사진을 저장하기 위해 갤러리 접근 권한이 필요합니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('확인'),
            ),
          ],
        ),
      );

      if (shouldProceed != true) return;

      var status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
        if (!status.isGranted) {
          throw Exception('갤러리 접근 권한이 필요합니다.');
        }
      }

      final boundary = repaintBoundary.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final capturedImage = await boundary.toImage(pixelRatio: 3.0);

      final templateAspectRatio = widget.template.getAspectRatio();
      final capturedAspectRatio = capturedImage.width / capturedImage.height;

      final resizedImage = await _cropAndResizeImage(
        capturedImage,
        templateAspectRatio,
        capturedAspectRatio,
      );

      final byteData =
          await resizedImage.toByteData(format: ui.ImageByteFormat.png);

      final result = await ImageGallerySaver.saveImage(
        byteData!.buffer.asUint8List(),
        quality: 100,
        name: 'collage.png',
      );

      if (!mounted) return;

      final message = result['isSuccess'] == true ? '저장 완료!' : '저장 실패';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make your own collage!"),
      ),
      body: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              key: repaintBoundary,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final templateSize = widget.template.layoutSize(constraints);

                  return Center(
                    child: Container(
                      width: templateSize.width,
                      height: templateSize.height,
                      color: Colors.white,
                      child: CollageFrameBuilder(
                        imageMap: imageMap,
                        template: widget.template,
                        onImageSelected: (cellId, image) {
                          setState(() {
                            imageMap[cellId] = image;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              if (widget.template.cells.length != imageMap.length) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('모든 셀에 이미지를 넣어주세요.')),
                );
              } else {
                _saveImage();
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 250,
              child: Text('이미지 저장', style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
