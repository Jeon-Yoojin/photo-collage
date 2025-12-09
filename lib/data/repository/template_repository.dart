import 'package:recall_scanner/data/database/cell_model.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'package:recall_scanner/data/isar_service.dart';

class TemplateRepository {
  Future<TemplateModel> saveTemplate(
      TemplateModel template, List<CellModel> cells) async {
    final isar = await IsarService.instance;

    await isar.writeTxn(() async {
      await isar.cellModels.putAll(cells);
      template.cells.addAll(cells);
      await isar.templateModels.put(template);
      await template.cells.save();
    });

    await template.cells.load();
    return template;
  }
}
