class FrameCell {
  final String id;
  double x;
  double y;
  double width;
  double height;
  double borderRadius;
  double rotation;
  String type;

  FrameCell({
    required this.id,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.borderRadius = 0,
    this.rotation = 0,
    required this.type,
  });
}
