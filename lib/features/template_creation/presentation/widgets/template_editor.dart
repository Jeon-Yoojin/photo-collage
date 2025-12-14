import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recall_scanner/common/utils/layout.dart';
import 'package:recall_scanner/data/database/cell_model.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'package:recall_scanner/data/repository/template_repository.dart';
import 'package:recall_scanner/models/frame_cell.dart';
import 'package:recall_scanner/provider/change_notifier.dart';

class TemplateEditorCanvas extends StatefulWidget {
  const TemplateEditorCanvas({super.key});

  @override
  State<TemplateEditorCanvas> createState() => _TemplateEditorCanvasState();
}

class _TemplateEditorCanvasState extends State<TemplateEditorCanvas> {
  FrameCell? selectedShape;
  static const double RESIZABLE_HANDLER_SIZE = 10;
  final MIN_WIDTH = 50.0;
  final MIN_HEIGHT = 50.0;
  List<FrameCell> shapes = [];

  double? selectedAspectRatio;
  BoxConstraints? _boxConstraints;

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
    final repo = TemplateRepository();
    final provider = Provider.of<TemplateProvider>(context, listen: false);

    if (_boxConstraints == null) return;

    final templateSize = calcTemplateSizeFromRatio(
      _boxConstraints!,
      aspectRatio: selectedAspectRatio ?? 1.0,
    );

    final template = TemplateModel()
      ..canvasWidth = templateSize.width
      ..canvasHeight = templateSize.height
      ..aspectRatio = selectedAspectRatio ?? 1.0;

    final cells = <CellModel>[];
    for (var shape in shapes) {
      final cell = CellModel()
        ..x = shape.x
        ..y = shape.y
        ..width = shape.width
        ..height = shape.height
        ..borderRadius = shape.borderRadius
        ..rotation = shape.rotation
        ..type = shape.type;

      cells.add(cell);
    }
    final savedTemplate = await repo.saveTemplate(template, cells);
    await provider.addTemplate(savedTemplate);
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

  List<FrameCell> _filterShapesByCanvas(
      List<FrameCell> shapes, double canvasWidth, double canvasHeight) {
    return shapes.where((shape) {
      return shape.x <= canvasWidth && shape.y <= canvasHeight;
    }).toList();
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
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(
                color: selectedShape == shape
                    ? Colors.grey[500]!
                    : Colors.grey[300]!,
                width: selectedShape == shape ? 3 : 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(shape.borderRadius),
          ),
          child: Center(
            child: Icon(
              Icons.photo,
              color: Colors.grey[400],
              size: 32,
            ),
          ),
        ),
        if (selectedShape == shape)
          Positioned(
            right: shape.type == 'circle'
                ? (shape.width / 2) * (1 - 1 / sqrt(2)) -
                    RESIZABLE_HANDLER_SIZE / 2
                : 0,
            bottom: shape.type == 'circle'
                ? (shape.height / 2) * (1 - 1 / sqrt(2)) -
                    RESIZABLE_HANDLER_SIZE / 2
                : 0,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanUpdate: (details) {
                if (selectedShape == shape) {
                  setState(() {
                    switch (shape.type) {
                      case 'circle':
                        var grow = max(details.delta.dx, details.delta.dy);
                        shape.width += grow;
                        shape.height += grow;
                        shape.borderRadius = shape.width / 2;
                        break;

                      default:
                        shape.width += details.delta.dx;
                        shape.height += details.delta.dy;
                    }

                    if (shape.width < MIN_WIDTH) shape.width = MIN_WIDTH;
                    if (shape.height < MIN_HEIGHT) shape.height = MIN_HEIGHT;
                  });
                }
              },
              child: selectedShape == shape
                  ? Container(
                      width: RESIZABLE_HANDLER_SIZE,
                      height: RESIZABLE_HANDLER_SIZE,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        shape: BoxShape.rectangle,
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

  Widget _buildCanvasSizeHandler(BoxConstraints constraints) {
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
          final isSelected = selectedAspectRatio != null &&
              (selectedAspectRatio! - ratioValue).abs() < 0.01;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(ratioString),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedAspectRatio = ratioValue;

                  final templateSize = calcTemplateSizeFromRatio(
                    constraints,
                    aspectRatio: ratioValue,
                  );

                  shapes = _filterShapesByCanvas(
                    shapes,
                    templateSize.width,
                    templateSize.height,
                  );

                  if (selectedShape != null &&
                      !shapes.any((s) => s.id == selectedShape!.id)) {
                    selectedShape = null;
                  }
                });
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          _boxConstraints = constraints;

          final templateSize = calcTemplateSizeFromRatio(
            constraints,
            aspectRatio: selectedAspectRatio ?? 1.0,
          );

          final visibleShapes = _filterShapesByCanvas(
              shapes, templateSize.width, templateSize.height);

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    width: templateSize.width,
                    height: templateSize.height,
                    color: Colors.white,
                    child: ClipRect(
                      child: Stack(children: [
                        ...visibleShapes.map((shape) => Positioned(
                              left: shape.x,
                              top: shape.y,
                              child: _buildResizable(shape, templateSize.width,
                                  templateSize.height),
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
                child: _buildCanvasSizeHandler(constraints),
              ),
            ],
          );
        },
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
                  double width = MIN_WIDTH * 2;
                  double height = MIN_HEIGHT * 2;
                  switch (type) {
                    case 'rectangle':
                      width *= 2;
                      break;
                  }
                  shapes.add(FrameCell(
                      id: UniqueKey().toString(),
                      type: type,
                      x: 50,
                      y: 50,
                      width: width,
                      height: height,
                      borderRadius: type == 'circle' ? width / 2 : 0));
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
