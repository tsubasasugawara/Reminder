import 'package:flutter/material.dart';

/// 明るさを計算
/// * `color` : 計算対象の色
/// * @return `double` : 明るさ
double brightness(Color color) {
  return (color.red * 299.0 + color.green * 587.0 + color.blue * 114.0) /
      1000.0;
}

/// 見やすい色(白か黒)を返す
/// * `color` : 判定する色
/// * @return `Color` : 白か黒
Color judgeBlackWhite(Color color) {
  double num = brightness(color);
  if (num < 128) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}
