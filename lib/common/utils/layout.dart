import 'dart:math';
import 'package:flutter/material.dart';

class TemplateSize {
  final double width;
  final double height;

  TemplateSize({required this.width, required this.height});
}

/// constraints와 aspectRatio를 기반으로 템플릿 크기를 계산합니다.
///
/// [constraints] LayoutBuilder에서 제공하는 BoxConstraints
///
/// [aspectRatio] 템플릿의 가로세로 비율, 기본값 1.0
///
/// [canvasWidth] 명시적으로 지정된 캔버스 너비 (선택사항)
///
/// [canvasHeight] 명시적으로 지정된 캔버스 높이 (선택사항)
///
/// Returns 계산된 템플릿 크기를 담은 [TemplateSize] 객체
TemplateSize calcTemplateSizeFromRatio(
  BoxConstraints constraints, {
  double aspectRatio = 1.0,
  double? canvasWidth,
  double? canvasHeight,
}) {
  double calculatedWidth;
  double calculatedHeight;

  if (canvasWidth != null && canvasHeight != null) {
    calculatedWidth = canvasWidth;
    calculatedHeight = canvasHeight;
  } else if (aspectRatio == 1.0) {
    final size = min(constraints.maxWidth, constraints.maxHeight);
    calculatedWidth = calculatedHeight = size;
  } else if (aspectRatio > 1.0) {
    calculatedWidth = constraints.maxWidth;
    calculatedHeight = calculatedWidth / aspectRatio;

    if (calculatedHeight > constraints.maxHeight) {
      calculatedHeight = constraints.maxHeight;
      calculatedWidth = calculatedHeight * aspectRatio;
    }
  } else {
    calculatedHeight = constraints.maxHeight;
    calculatedWidth = calculatedHeight * aspectRatio;

    if (calculatedWidth > constraints.maxWidth) {
      calculatedWidth = constraints.maxWidth;
      calculatedHeight = calculatedWidth / aspectRatio;
    }
  }

  return TemplateSize(width: calculatedWidth, height: calculatedHeight);
}
