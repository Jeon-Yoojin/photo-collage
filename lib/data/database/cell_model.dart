import 'package:isar/isar.dart';

part 'cell_model.g.dart';

@collection
class CellModel {
  Id id = Isar.autoIncrement;

  late double x;
  late double y;
  late double width;
  late double height;

  late double borderRadius;
  late double rotation;
  late String type;
}
