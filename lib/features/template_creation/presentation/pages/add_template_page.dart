import 'package:flutter/material.dart';
import 'package:recall_scanner/features/template_creation/presentation/widgets/template_editor.dart';

class AddTemplatePage extends StatefulWidget {
  const AddTemplatePage({super.key});

  @override
  State<AddTemplatePage> createState() => _AddTemplatePageState();
}

class _AddTemplatePageState extends State<AddTemplatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Template')),
      body: TemplateEditorCanvas(),
    );
  }
}
