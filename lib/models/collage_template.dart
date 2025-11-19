import 'collage_row.dart';

class CollageTemplate {
  final List<CollageRow> rows;
  CollageTemplate({required this.rows});

  factory CollageTemplate.fromJson(Map<String, dynamic> json) {
    return CollageTemplate(
      rows: (json['rows'] as List).map((r) => CollageRow.fromJson(r)).toList(),
    );
  }
}

