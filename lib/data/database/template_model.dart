import 'package:isar/isar.dart';
import 'cell_model.dart';

part 'template_model.g.dart';

@collection
class TemplateModel {
  Id id = Isar.autoIncrement;

  late double canvasWidth;
  late double canvasHeight;
  late double aspectRatio;

  final cells = IsarLinks<CellModel>();
}
