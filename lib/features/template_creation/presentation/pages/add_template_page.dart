import 'package:flutter/material.dart';
import 'package:recall_scanner/models/frame_cell.dart';

// template 편집할 수 있는 페이지
/* 
 n개의 이미지를 선택해서, 자유롭게 배치하고
 그것을 CollageTemplate로 변환하여 반환
 각각의 이미지는 0 ~ n-1 인덱스를 가지며,
 기본적으로 형성되는 CollageTemplate에 수평, 수직 여백 값을 조절하여 형성됨
 */
class AddTemplatePage extends StatefulWidget {
  const AddTemplatePage({super.key});

  @override
  State<AddTemplatePage> createState() => _AddTemplatePageState();
}

class _AddTemplatePageState extends State<AddTemplatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Template')),
      body: Column(children: [
        // collage template
        Expanded(
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemCount: 10, // 임시로 10개 설정
            itemBuilder: (context, index) {
              return Container(
                color: Colors.red,
                child: Text('Cell $index'),
              );
            },
          ),
        )
      ]),
    );
  }
}

class CollageTemplateNew {
  final List<FrameCell> cells;
  CollageTemplateNew({required this.cells});
}
