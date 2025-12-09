import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'package:recall_scanner/provider/change_notifier.dart';
import '../../../editor/presentation/pages/editor_page.dart';
import '../../../template_creation/presentation/pages/add_template_page.dart';

class TemplatePreviewPage extends StatefulWidget {
  const TemplatePreviewPage({super.key});

  @override
  State<TemplatePreviewPage> createState() => _TemplatePreviewPageState();
}

class _TemplatePreviewPageState extends State<TemplatePreviewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Template')),
      body: LayoutBuilder(builder: (context, constraints) {
        final itemSize = constraints.maxWidth / 2;

        return Consumer<TemplateProvider>(
          builder: (context, templateProvider, child) {
            if (templateProvider.templates.isEmpty) {
              return Center(child: Text('템플릿이 없습니다'));
            }
            return GridView.count(
              padding: const EdgeInsets.all(5),
              crossAxisCount: 2,
              children: _getTemplates(
                context: context,
                templates: templateProvider.templates,
                itemSize: itemSize,
              ),
            );
          },
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

  List<Widget> _getTemplates({
    required BuildContext context,
    required List<TemplateModel> templates,
    required double itemSize,
  }) {
    return [
      for (var template in templates)
        SizedBox(
          width: itemSize,
          height: itemSize,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildTemplatePreview(context, template),
          ),
        ),
    ];
  }
}
