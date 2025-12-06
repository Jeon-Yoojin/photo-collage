import 'package:flutter/material.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import '../../../editor/presentation/pages/editor_page.dart';
import '../../../template_creation/presentation/pages/add_template_page.dart';

class TemplatePreviewPage extends StatelessWidget {
  final List<TemplateModel> templates;
  const TemplatePreviewPage({required this.templates, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Template')),
      body: LayoutBuilder(builder: (context, constraints) {
        final itemSize = constraints.maxWidth / 2;

        return GridView.count(
          padding: const EdgeInsets.all(5),
          crossAxisCount: 2,
          children: [
            for (var template in templates)
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

  Widget _buildTemplatePreview(BuildContext context, TemplateModel template) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPhotoPage(template: template),
            ));
      },
      child: Container(
        color: Colors.white,
        child: Container(
            // 임시로 id 출력
            alignment: Alignment.center,
            child: Text(template.id.toString())),
      ),
    );
  }
}
