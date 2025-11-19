import 'collage_cell.dart';

class CollageRow {
  final List<CollageCell> cells;
  CollageRow({required this.cells});

  factory CollageRow.fromJson(Map<String, dynamic> json) {
    return CollageRow(
      cells:
          (json['cells'] as List).map((c) => CollageCell.fromJson(c)).toList(),
    );
  }
}

