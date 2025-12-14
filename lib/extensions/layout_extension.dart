// template_model.dart 또는 별도 extension 파일
import 'package:flutter/rendering.dart';
import 'package:recall_scanner/common/utils/layout.dart';
import 'package:recall_scanner/data/database/template_model.dart';

extension TemplateModelExtension on TemplateModel {
  double getAspectRatio() {
    return canvasWidth > 0 && canvasHeight > 0
        ? canvasWidth / canvasHeight
        : aspectRatio;
  }

  TemplateSize layoutSize(BoxConstraints constraints) {
    return calcTemplateSizeFromRatio(
      constraints,
      aspectRatio: getAspectRatio(),
      canvasWidth: canvasWidth > 0 ? canvasWidth : null,
      canvasHeight: canvasHeight > 0 ? canvasHeight : null,
    );
  }
}
