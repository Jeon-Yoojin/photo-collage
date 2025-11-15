import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Collage',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),
      home: SelectPhotoTemplatePage(),
    );
  }
}

class GridSelectPage extends StatelessWidget {
  final List<List<CollageTemplate>> templates;
  const GridSelectPage({required this.templates, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Grid')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16, // 수직 간격
          crossAxisSpacing: 16, // 수평 간격
          childAspectRatio: 1, // 아이템의 가로/세로 비율
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TemplatePreviewPage(templates: templates)));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.grid_view, size: 48),
                  SizedBox(height: 8),
                  Text('Grid ${index + 1}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SelectPhotoTemplatePage extends StatefulWidget {
  // photo template 선택
  late int photoCount;

  SelectPhotoTemplatePage({super.key});

  @override
  State<SelectPhotoTemplatePage> createState() =>
      _SelectPhotoTemplatePageState();
}

class _SelectPhotoTemplatePageState extends State<SelectPhotoTemplatePage> {
  late int photoCount;

  @override
  void initState() {
    super.initState();
    photoCount = widget.photoCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Photo Template')),
      body: Column(
        children: [
          Text('Photo Count: $photoCount'),
          DropdownButton<int>(
            items: [
              DropdownMenuItem(value: 1, child: Text('1')),
              DropdownMenuItem(value: 2, child: Text('2')),
              DropdownMenuItem(value: 3, child: Text('3')),
              DropdownMenuItem(value: 4, child: Text('4')),
              DropdownMenuItem(value: 5, child: Text('5')),
              DropdownMenuItem(value: 6, child: Text('6')),
              DropdownMenuItem(value: 7, child: Text('7')),
              DropdownMenuItem(value: 8, child: Text('8')),
              DropdownMenuItem(value: 9, child: Text('9'))
            ],
            onChanged: (value) {
              setState(() {
                photoCount = value!;
                templates = _generateTemplates();
              });
            },
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TemplatePreviewPage(templates: templates),
                  ));
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  List<List<CollageTemplate>> templates = [];

  List<List<CollageTemplate>> _generateTemplates() {
    final photoCount = this.photoCount;
    List<List<CollageTemplate>> result = [];

    // 각 이미지 개수(i+1개)에 대한 레이아웃 생성
    List<CollageTemplate> layoutsForCount = [];

    // 열 개수(j)를 1부터 이미지 개수의 제곱근까지
    final maxCols = math.min(photoCount, math.sqrt(photoCount).ceil());
    for (int j = 1; j <= maxCols; j++) {
      final quotient = photoCount ~/ j; // 꽉 채워지는 행의 개수
      final rest = photoCount % j; // 나머지 사진 개수

      if (rest == 0) {
        // 나머지가 없으면 한 가지 경우만 가능
        List<CollageRow> rows = [];
        for (int row = 0; row < quotient; row++) {
          rows.add(
              CollageRow(cells: List.generate(j, (_) => CollageCell(flex: 1))));
        }
        layoutsForCount.add(CollageTemplate(rows: rows));
      } else {
        // 나머지 rest개 사진을 배치하는 모든 경우의 수
        // 나머지가 위치할 수 있는 행: 0번째 ~ quotient번째 (총 quotient+1개의 위치)

        // 나머지를 마지막 행(quotient번째)에 배치
        List<CollageRow> rows = [];
        for (int row = 0; row < quotient; row++) {
          rows.add(
              CollageRow(cells: List.generate(j, (_) => CollageCell(flex: 1))));
        }
        rows.add(CollageRow(
            cells: List.generate(rest, (_) => CollageCell(flex: 1))));
        layoutsForCount.add(CollageTemplate(rows: rows));

        // 나머지를 기존 행들 중 어디든 배치할 수 있는 경우
        // (단, 각 행은 최대 j개까지 가능하므로 나머지가 j 이하일 때만 가능)
        if (rest <= j && quotient > 0) {
          // 각 기존 행에 나머지를 배치하는 경우
          for (int insertRow = 0; insertRow < quotient; insertRow++) {
            List<CollageRow> rows = [];
            for (int row = 0; row < quotient; row++) {
              if (row == insertRow) {
                // 이 행에 나머지 추가
                rows.add(CollageRow(
                    cells:
                        List.generate(j + rest, (_) => CollageCell(flex: 1))));
              } else {
                rows.add(CollageRow(
                    cells: List.generate(j, (_) => CollageCell(flex: 1))));
              }
            }
            layoutsForCount.add(CollageTemplate(rows: rows));
          }
        }
      }
    }

    result.add(layoutsForCount);

    return result;
  }
}

class TemplatePreviewPage extends StatelessWidget {
  final List<List<CollageTemplate>> templates;
  const TemplatePreviewPage({required this.templates, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Template')),
      body: ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) {
          for (var template in templates[index]) {
            return _buildTemplatePreview(template);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildTemplatePreview(CollageTemplate template) {
    return Container(
      color: Colors.white,
      child: CollageFrameBuilder(template: template, images: []),
    );
  }
}

class EditPhotoPage extends StatefulWidget {
  final int grid;
  final List<List<CollageTemplate>> templates;
  const EditPhotoPage({super.key, required this.grid, required this.templates});

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  final repaintBoundary = GlobalKey();
  List<XFile> images = <XFile>[];
  String _error = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  Future<void> getImage() async {
    try {
      final List<XFile> selectedImages = await _picker.pickMultiImage();
      if (!mounted) return;

      setState(() {
        images = selectedImages;
        _error = '';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
      });
    }
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
      final image = await boundary.toImage(pixelRatio: 2);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      final result = await ImageGallerySaver.saveImage(
        byteData!.buffer.asUint8List(),
        quality: 60,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: getImage,
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 250,
                child: Text('이미지 선택', style: TextStyle(fontSize: 20)),
              ),
            ),
            if (_error.isNotEmpty)
              Text(
                'Error: $_error',
                style: TextStyle(color: Colors.red),
              ),
            if (images.isNotEmpty)
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: RepaintBoundary(
                        key: repaintBoundary,
                        child: Column(
                          children: [
                            for (var template in widget.templates[widget.grid])
                              CollageFrameBuilder(
                                images: images,
                                template: template,
                              )
                          ],
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _saveImage,
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 250,
                        child: Text('이미지 저장', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

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

class CollageTemplate {
  final List<CollageRow> rows;
  CollageTemplate({required this.rows});

  factory CollageTemplate.fromJson(Map<String, dynamic> json) {
    return CollageTemplate(
      rows: (json['rows'] as List).map((r) => CollageRow.fromJson(r)).toList(),
    );
  }
}

class CollageRow {
  final List<CollageCell> cells;
  CollageRow({required this.cells});

  factory CollageRow.fromJson(Map<String, dynamic> json) {
    return CollageRow(
      cells:
          (json['cells'] as List).map((c) => CollageCell.fromJson(c)).toList(),
    );
  }
}

class CollageCell {
  final int flex;
  final double? width;
  final String? align;

  CollageCell({required this.flex, this.width, this.align});

  factory CollageCell.fromJson(Map<String, dynamic> json) {
    return CollageCell(
      flex: json['flex'] ?? 1,
      width: json['width']?.toDouble(),
      align: json['align'],
    );
  }
}

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
