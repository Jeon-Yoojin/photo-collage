import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'package:recall_scanner/data/isar_service.dart';

class TemplateProvider extends ChangeNotifier {
  List<TemplateModel> templates = [];

  TemplateProvider() {
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    final isar = await IsarService.instance;
    final loadedTemplates = await isar.templateModels.where().findAll();

    for (var template in loadedTemplates) {
      await template.cells.load();
    }

    templates = loadedTemplates;

    notifyListeners();
  }

  Future<void> addTemplate(TemplateModel template) async {
    templates.add(template);
    notifyListeners();
  }
}
