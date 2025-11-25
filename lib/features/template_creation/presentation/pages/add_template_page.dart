import 'package:flutter/material.dart';
import 'package:recall_scanner/features/template_creation/presentation/widgets/template_editor.dart';
import 'package:recall_scanner/models/frame_cell.dart';

class AddTemplatePage extends StatefulWidget {
  const AddTemplatePage({super.key});

  @override
  State<AddTemplatePage> createState() => _AddTemplatePageState();
}

class _AddTemplatePageState extends State<AddTemplatePage> {
  double? selectedAspectRatio;

  void _setSelectedAspectRatio(double aspectRatio) {
    setState(() {
      selectedAspectRatio = aspectRatio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Template')),
      // body: Column(children: [
      //   // collage template
      //   Expanded(
      //     child: GridView.builder(
      //       gridDelegate:
      //           SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      //       itemCount: 3,
      //       itemBuilder: (context, index) {
      //         return CollageTemplateBuilder(
      //             template: CollageTemplateNew(cells: [
      //           FrameCell(
      //               id: index.toString(),
      //               x: (index % 2) * 0.5,
      //               y: (index ~/ 2) * 0.5,
      //               width: 0.5,
      //               height: 0.5,
      //               borderRadius: 30,
      //               rotation: index % 2 * 45)
      //         ]));
      //       },
      //     ),
      //   )
      // ]),
      body: TemplateEditorCanvas(
          selectedAspectRatio: selectedAspectRatio,
          setSelectedAspectRatio: _setSelectedAspectRatio),
    );
  }
}

class CollageTemplateNew {
  final List<FrameCell> cells;
  CollageTemplateNew({required this.cells});
}
