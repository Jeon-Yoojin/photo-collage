class CollageCell {
  final int flex;
  final double? width;
  final String? align;

  CollageCell({required this.flex, this.width, this.align});

  factory CollageCell.fromJson(Map<String, dynamic> json) {
    return CollageCell(
      flex: json['flex'] ?? 1,
      width: json['width']?.toDouble(),
      align: json['align'],
    );
  }
}
