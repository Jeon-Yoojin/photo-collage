import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recall_scanner/data/database/cell_model.dart';
import 'package:recall_scanner/data/database/template_model.dart';

class IsarService {
  static Isar? _isar;

  static Future<Isar> get instance async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TemplateModelSchema, CellModelSchema],
      directory: dir.path,
      name: 'templates',
    );

    return _isar!;
  }
}
