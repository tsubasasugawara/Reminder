import 'package:flutter/material.dart';

double brightness(Color color) {
  return (color.red * 299.0 + color.green * 587.0 + color.blue * 114.0) /
      1000.0;
}

Color judgeBlackWhite(Color color) {
  double num = brightness(color);
  if (num < 128) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}
