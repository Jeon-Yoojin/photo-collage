import 'package:flutter/material.dart';
import 'package:recall_scanner/data/database/cell_model.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'package:recall_scanner/data/isar_service.dart';
import 'package:recall_scanner/models/frame_cell.dart';

class TemplateEditorCanvas extends StatefulWidget {
  final double? selectedAspectRatio;
  final double? canvasWidth;
  final double? canvasHeight;
  final Function(double) setSelectedAspectRatio;

  const TemplateEditorCanvas({
    super.key,
    this.selectedAspectRatio,
    this.canvasWidth,
    this.canvasHeight,
    required this.setSelectedAspectRatio,
  });

  @override
  State<TemplateEditorCanvas> createState() => _TemplateEditorCanvasState();
}

class _TemplateEditorCanvasState extends State<TemplateEditorCanvas> {
  FrameCell? selectedShape;
  static const double resizeable_handle_size = 16;
  List<FrameCell> shapes = [];

  final List<String> addableWidgets = ['rectangle', 'square', 'circle'];

  void deleteItem() {
    setState(() {
      if (selectedShape != null) {
        shapes.removeWhere((shape) => shape.id == selectedShape!.id);
      }
      selectedShape = null;
    });
  }

  Future<void> saveTemplate() async {
    final isar = await IsarService.instance;

    final template = TemplateModel()
      ..canvasWidth = widget.canvasWidth ?? 0
      ..canvasHeight = widget.canvasHeight ?? 0
      ..aspectRatio = widget.selectedAspectRatio ?? 1.0;

    await isar.writeTxn(() async {
      await isar.templateModels.put(template);

      for (var shape in shapes) {
        final cell = CellModel()
          ..x = shape.x
          ..y = shape.y
          ..width = shape.width
          ..height = shape.height
          ..borderRadius = shape.borderRadius
          ..rotation = shape.rotation
          ..type = shape.type;

        await isar.cellModels.put(cell);

        template.cells.add(cell);
      }

      await template.cells.save();
    });
  }

  IconData _getShapeIcon(String shape) {
    switch (shape) {
      case 'rectangle':
        return Icons.crop_free;
      case 'square':
        return Icons.crop_square;
      case 'circle':
        return Icons.radio_button_unchecked;
      default:
        return Icons.add;
    }
  }

  Widget _buildFloatingMenu(FrameCell shape) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.copy, size: 20),
            onPressed: () {
              setState(() {
                shapes.add(FrameCell(
                  id: UniqueKey().toString(),
                  type: shape.type,
                  x: shape.x + 20,
                  y: shape.y + 20,
                  width: shape.width,
                  height: shape.height,
                  borderRadius: shape.borderRadius,
                  rotation: shape.rotation,
                ));
              });
            },
            tooltip: '복사',
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(),
          ),
          IconButton(
            icon: Icon(Icons.flip_to_front),
            onPressed: () {
              setState(() {
                int index = shapes.indexOf(shape);
                if (index == shapes.length - 1) return;

                shapes.removeAt(index);
                shapes.insert(index + 1, shape);
              });
            },
            tooltip: '앞으로 가져오기',
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(),
          ),
          IconButton(
            icon: Icon(Icons.flip_to_back),
            onPressed: () {
              setState(() {
                int index = shapes.indexOf(shape);
                if (index == 0) return;

                shapes.removeAt(index);
                shapes.insert(index - 1, shape);
              });
            },
            tooltip: '뒤로 보내기',
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(),
          )
        ],
      ),
    );
  }

  Widget _buildResizable(
      FrameCell shape, double? canvasWidth, double? canvasHeight) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          selectedShape = null;
          double newX = shape.x + details.delta.dx;
          double newY = shape.y + details.delta.dy;

          // canvas 경계 체크
          if (canvasWidth != null && canvasHeight != null) {
            if (newX < 0) newX = 0;
            if (newX + shape.width > canvasWidth) {
              newX = canvasWidth - shape.width;
            }

            if (newY < 0) newY = 0;
            if (newY + shape.height > canvasHeight) {
              newY = canvasHeight - shape.height;
            }
          }

          shape.x = newX;
          shape.y = newY;
        });
      },
      onTap: () {
        setState(() {
          selectedShape = shape;
        });
      },
      child: Stack(children: [
        Container(
          width: shape.width,
          height: shape.height,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(
                color: selectedShape == shape
                    ? Colors.grey[500]!
                    : Colors.grey[300]!,
                width: selectedShape == shape ? 3 : 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(shape.borderRadius),
            boxShadow: selectedShape == shape
                ? [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Icon(
              Icons.photo,
              color: Colors.grey[400],
              size: 32,
            ),
          ),
        ),
        Positioned(
          right: -8,
          bottom: -8,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanUpdate: (details) {
              if (selectedShape == shape) {
                setState(() {
                  shape.width += details.delta.dx;
                  shape.height += details.delta.dy;

                  if (shape.width < 50) shape.width = 50;
                  if (shape.height < 50) shape.height = 50;
                });
              }
            },
            child: selectedShape == shape
                ? Container(
                    width: resizeable_handle_size,
                    height: resizeable_handle_size,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(),
                      shape: BoxShape.circle,
                    ),
                  )
                : SizedBox.shrink(),
          ),
        )
      ]),
    );
  }

  double _parseAspectRatio(String ratio) {
    final parts = ratio.split(':');
    if (parts.length != 2) return 1.0;
    final width = double.tryParse(parts[0]) ?? 1.0;
    final height = double.tryParse(parts[1]) ?? 1.0;
    return width / height;
  }

  Widget _buildCanvasSizeHandler() {
    final List<String> aspectRatioStrings = [
      '1:1',
      '4:5',
      '9:16',
      '3:4',
      '16:9',
      '3:2'
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: aspectRatioStrings.map((ratioString) {
          final ratioValue = _parseAspectRatio(ratioString);
          final isSelected = widget.selectedAspectRatio != null &&
              (widget.selectedAspectRatio! - ratioValue).abs() < 0.01;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(ratioString),
              selected: isSelected,
              onSelected: (selected) {
                widget.setSelectedAspectRatio(ratioValue);
              },
              selectedColor: Colors.blue.withValues(alpha: 0.3),
              checkmarkColor: Colors.blue,
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                double canvasWidth;
                double canvasHeight;

                // width와 height가 명시적으로 지정된 경우
                if (widget.canvasWidth != null && widget.canvasHeight != null) {
                  canvasWidth = widget.canvasWidth!;
                  canvasHeight = widget.canvasHeight!;
                } else if (widget.selectedAspectRatio != null) {
                  final aspectRatio = widget.selectedAspectRatio!;
                  // 가로가 더 긴 경우 (landscape)
                  if (aspectRatio >= 1.0) {
                    canvasWidth = constraints.maxWidth;
                    canvasHeight = canvasWidth / aspectRatio;
                  }
                  // 세로가 더 긴 경우 (portrait)
                  else {
                    canvasHeight = constraints.maxHeight;
                    canvasWidth = canvasHeight * aspectRatio;
                  }
                }
                // default (1:1)
                else {
                  final size = constraints.maxWidth < constraints.maxHeight
                      ? constraints.maxWidth
                      : constraints.maxHeight;
                  canvasWidth = size;
                  canvasHeight = size;
                }

                return Center(
                  child: Container(
                    width: canvasWidth,
                    height: canvasHeight,
                    color: Colors.white,
                    child: ClipRect(
                      child: Stack(children: [
                        ...shapes.map((shape) => Positioned(
                              left: shape.x,
                              top: shape.y,
                              child: _buildResizable(
                                  shape, canvasWidth, canvasHeight),
                            )),
                        if (selectedShape != null)
                          Positioned(
                            left: selectedShape!.x + selectedShape!.width / 2,
                            top: selectedShape!.y - 50,
                            child: Transform.translate(
                              offset: Offset(-40, 0),
                              child: _buildFloatingMenu(selectedShape!),
                            ),
                          ),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: _buildCanvasSizeHandler(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PopupMenuButton<String>(
              icon: Icon(Icons.add),
              itemBuilder: (context) => [
                for (var shape in addableWidgets)
                  PopupMenuItem(
                    value: shape,
                    child: Row(
                      children: [
                        Icon(_getShapeIcon(shape)),
                        SizedBox(width: 8),
                        Text(shape),
                      ],
                    ),
                  ),
              ],
              onSelected: (String type) {
                setState(() {
                  shapes.add(FrameCell(
                      id: UniqueKey().toString(),
                      type: type,
                      x: 50,
                      y: 50,
                      width: 100,
                      height: 100));
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteItem();
              },
              tooltip: '삭제',
            ),
            IconButton(
                icon: Icon(Icons.add_reaction_sharp),
                onPressed: () {
                  // 팝업 형태
                },
                tooltip: '스티커 추가'),
            IconButton(
              icon: Icon(Icons.undo),
              onPressed: () {},
              tooltip: '실행 취소',
            ),
            IconButton(
              icon: Icon(Icons.redo),
              onPressed: () {},
              tooltip: '다시 실행',
            ),
            IconButton(
                onPressed: () {
                  saveTemplate();
                },
                icon: Icon(Icons.save))
          ],
        ),
      ),
    );
  }
}
