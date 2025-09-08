import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter_image_saver/flutter_image_saver.dart';

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
      home: GridSelectPage(),
    );
  }
}

class GridSelectPage extends StatelessWidget {
  const GridSelectPage({super.key});

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
                  MaterialPageRoute(builder: (context) => EditPhotoPage()),
                );
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

class EditPhotoPage extends StatefulWidget {
  const EditPhotoPage({super.key});

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  final repaintBoundary = GlobalKey();
  List<XFile> images = <XFile>[];
  String _error = '';
  final ImagePicker _picker = ImagePicker();

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

  Future<void> saveImage() async {
    try {
      final boundary = repaintBoundary.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      // flutter_image_saver 패키지 사용
      final result = await FlutterImageSaver.saveImage(
        byteData!.buffer.asUint8List(),
        name: 'collage.png',
      );

      final message = result ? 'Saved successfully' : 'Failed to save';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      print("Error: $e");
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
              RepaintBoundary(
                  key: repaintBoundary,
                  child: Expanded(
                    child: GridView.builder(
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
                    ),
                  )),
            OutlinedButton(
              onPressed: saveImage,
              child: Container(
                alignment: Alignment.center,
                height: 30,
                width: 250,
                child: Text('이미지 선택', style: TextStyle(fontSize: 20)),
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
