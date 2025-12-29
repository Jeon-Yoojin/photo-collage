class Sticker {
  final int id;
  final String imgPath;
  double x;
  double y;
  double width;
  double height;
  double rotation;

  Sticker({
    required this.id,
    required this.imgPath,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.rotation = 0,
  });
}
