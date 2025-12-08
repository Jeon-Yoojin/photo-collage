import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:recall_scanner/data/database/template_model.dart';
import 'package:recall_scanner/data/isar_service.dart';
import 'dart:math' as math;
import '../../../../models/collage_template.dart';
import '../../../../models/collage_row.dart';
import '../../../../models/collage_cell.dart';
import '../widgets/template_preview_page.dart';

class SelectPhotoTemplatePage extends StatefulWidget {
  // photo template 선택
  const SelectPhotoTemplatePage({super.key});

  @override
  State<SelectPhotoTemplatePage> createState() =>
      _SelectPhotoTemplatePageState();
}

class _SelectPhotoTemplatePageState extends State<SelectPhotoTemplatePage> {
  int photoCount = 1;
  late List<TemplateModel> templates;

  @override
  void initState() {
    super.initState();
    _getTemplates().then((value) {
      setState(() {
        templates = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Photo Template')),
      body: Column(
        children: [
          Text('Photo Count: $photoCount'),
          DropdownButton<int>(
            items: [
              DropdownMenuItem(value: 1, child: Text('1')),
              DropdownMenuItem(value: 2, child: Text('2')),
              DropdownMenuItem(value: 3, child: Text('3')),
              DropdownMenuItem(value: 4, child: Text('4')),
              DropdownMenuItem(value: 5, child: Text('5')),
              DropdownMenuItem(value: 6, child: Text('6')),
              DropdownMenuItem(value: 7, child: Text('7')),
              DropdownMenuItem(value: 8, child: Text('8')),
              DropdownMenuItem(value: 9, child: Text('9'))
            ],
            onChanged: (value) {
              setState(() {
                photoCount = value!;
              });
            },
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TemplatePreviewPage(),
                  ));
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  Future<List<TemplateModel>> _getTemplates() async {
    final isar = await IsarService.instance;
    return await isar.templateModels.where().findAll();
  }

  List<List<CollageTemplate>> _generateTemplates() {
    final photoCount = this.photoCount;
    List<List<CollageTemplate>> result = [];

    // 각 이미지 개수(i+1개)에 대한 레이아웃 생성
    List<CollageTemplate> layoutsForCount = [];

    // 열 개수(j)를 1부터 이미지 개수의 제곱근까지
    final maxCols = math.min(photoCount, math.sqrt(photoCount).ceil());
    for (int j = 1; j <= maxCols; j++) {
      final quotient = photoCount ~/ j; // 꽉 채워지는 행의 개수
      final rest = photoCount % j; // 나머지 사진 개수

      if (rest == 0) {
        // 나머지가 없으면 한 가지 경우만 가능
        List<CollageRow> rows = [];
        for (int row = 0; row < quotient; row++) {
          rows.add(
              CollageRow(cells: List.generate(j, (_) => CollageCell(flex: 1))));
        }
        layoutsForCount.add(CollageTemplate(rows: rows));
      } else {
        // 나머지 rest개 사진을 배치하는 모든 경우의 수
        // 나머지가 위치할 수 있는 행: 0번째 ~ quotient번째 (총 quotient+1개의 위치)

        // 나머지를 마지막 행(quotient번째)에 배치
        List<CollageRow> rows = [];
        for (int row = 0; row < quotient; row++) {
          rows.add(
              CollageRow(cells: List.generate(j, (_) => CollageCell(flex: 1))));
        }
        rows.add(CollageRow(
            cells: List.generate(rest, (_) => CollageCell(flex: 1))));
        layoutsForCount.add(CollageTemplate(rows: rows));

        // 나머지를 기존 행들 중 어디든 배치할 수 있는 경우
        // (단, 각 행은 최대 j개까지 가능하므로 나머지가 j 이하일 때만 가능)
        if (rest <= j && quotient > 0) {
          // 각 기존 행에 나머지를 배치하는 경우
          for (int insertRow = 0; insertRow < quotient; insertRow++) {
            List<CollageRow> rows = [];
            for (int row = 0; row < quotient; row++) {
              if (row == insertRow) {
                // 이 행에 나머지 추가
                rows.add(CollageRow(
                    cells:
                        List.generate(j + rest, (_) => CollageCell(flex: 1))));
              } else {
                rows.add(CollageRow(
                    cells: List.generate(j, (_) => CollageCell(flex: 1))));
              }
            }
            layoutsForCount.add(CollageTemplate(rows: rows));
          }
        }
      }
    }

    result.add(layoutsForCount);

    return result;
  }
}
