import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
            if (images.isNotEmpty) Text('선택된 이미지: ${images.length}개'),
          ],
        ),
      ),
    );
  }
}
