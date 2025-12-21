import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'package:permission_handler/permission_handler.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'package:recall_scanner/extensions/layout_extension.dart';
import 'package:recall_scanner/features/editor/presentation/widgets/sticker_picker_sheet.dart';
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
  Color? selectedFrameColor = Colors.white;
  bool _isColorPaletteVisible = false;

  // 색상 팔레트 목록
  final List<Color> colorPalette = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

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

  void _toggleColorPalette() {
    setState(() {
      _isColorPaletteVisible = !_isColorPaletteVisible;
    });
  }

  void _selectColor(Color color) {
    setState(() {
      selectedFrameColor = color;
      _isColorPaletteVisible = false;
    });
  }

  Widget _buildColorPaletteBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: colorPalette.length,
        itemBuilder: (context, index) {
          final color = colorPalette[index];
          final isSelected = selectedFrameColor == color;
          final brightness = ThemeData.estimateBrightnessForColor(color);
          final checkIconColor =
              brightness == Brightness.dark ? Colors.white : Colors.black;

          return GestureDetector(
            onTap: () => _selectColor(color),
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? Colors.black
                      : Colors.grey.withValues(alpha: 0.3),
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? Icon(Icons.check, color: checkIconColor, size: 24)
                  : null,
            ),
          );
        },
      ),
    );
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
      final capturedImage = await boundary.toImage(pixelRatio: 5.0);

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
                      color: selectedFrameColor,
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isColorPaletteVisible ? 80 : 0,
            // clipBehavior: Clip.hardEdge,
            child: _isColorPaletteVisible
                ? _buildColorPaletteBar()
                : SizedBox.shrink(),
          ),
          BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.draw_sharp),
                  itemBuilder: (context) => [
                    // for (var shape in addableWidgets)
                    //   PopupMenuItem(
                    //     value: shape,
                    //     child: Row(
                    //       children: [
                    //         Icon(_getShapeIcon(shape)),
                    //         SizedBox(width: 8),
                    //         Text(shape),
                    //       ],
                    //     ),
                    //   ),
                  ],
                  onSelected: (String type) {},
                ),
                IconButton(
                  icon: Icon(Icons.color_lens),
                  onPressed: _toggleColorPalette,
                  tooltip: '프레임 색 변경',
                  color: _isColorPaletteVisible
                      ? Theme.of(context).primaryColor
                      : null,
                ),
                IconButton(
                  icon: Icon(Icons.add_reaction_sharp),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return StickerPickerSheet(
                          onStickerSelected: (sticker) {
                            // TODO: sticker 추가
                          },
                        );
                      },
                    );
                  },
                  tooltip: '스티커 추가',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
