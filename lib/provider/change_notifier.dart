import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'package:recall_scanner/data/isar_service.dart';

class Template extends ChangeNotifier {
  List<TemplateModel> templates = [];

  // 데이터베이스에서 템플릿 로드
  Future<void> loadTemplates() async {
    final isar = await IsarService.instance;
    final loadedTemplates = await isar.templateModels.where().findAll();

    // 각 템플릿의 cells를 로드
    for (var template in loadedTemplates) {
      await template.cells.load();
    }

    templates = loadedTemplates;
    notifyListeners();
  }

  void addTemplate(TemplateModel template) {
    templates.add(template);
    notifyListeners();
  }
}
