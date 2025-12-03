import 'package:flutter/material.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import '../../../template_selection/presentation/widgets/template_preview_page.dart';

class GridSelectPage extends StatelessWidget {
  final List<TemplateModel> templates;
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
