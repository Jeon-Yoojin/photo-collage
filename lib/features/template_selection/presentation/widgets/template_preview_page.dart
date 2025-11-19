import 'package:flutter/material.dart';
import '../../../../models/collage_template.dart';
import '../../../editor/presentation/pages/editor_page.dart';
import '../../../editor/presentation/widgets/collage_frame_builder.dart';
import '../../../template_creation/presentation/pages/add_template_page.dart';

class TemplatePreviewPage extends StatelessWidget {
  final List<List<CollageTemplate>> templates;
  const TemplatePreviewPage({required this.templates, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Template')),
      body: LayoutBuilder(builder: (context, constraints) {
        final itemSize = constraints.maxWidth / 2;

        return Wrap(
          spacing: 0,
          runSpacing: 0,
          children: [
            for (var templateList in templates)
              for (var template in templateList)
                SizedBox(
                  width: itemSize,
                  height: itemSize,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildTemplatePreview(context, template)),
                ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTemplatePage()),
          );
        },
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget _buildTemplatePreview(BuildContext context, CollageTemplate template) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPhotoPage(template: template),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: CollageFrameBuilder(template: template, images: []),
      ),
    );
  }
}
