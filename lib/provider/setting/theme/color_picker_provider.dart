import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/text_field_cursor/text_field_cursor.dart';

class ColorPickerProvider extends ChangeNotifier {
  /// 選択している色のindex
  late int _checkedItemIndex;

  /// 0~255
  late int _red;
  late int _green;
  late int _blue;

  TextEditingController rController = TextEditingController();
  TextEditingController gController = TextEditingController();
  TextEditingController bController = TextEditingController();

  /// コンストラクタ
  /// * `checkedItemIndex` : 選択されている色のindex
  /// * `primaryColor` : 現在のプライマリーカラー
  ColorPickerProvider(int checkedItemIndex, Color primaryColor) {
    _init(checkedItemIndex, primaryColor);
  }

  /// 初期化
  /// * `index` : 選択されている色のindex
  /// * `color` : 現在のプライマリーカラー
  void _init(int index, Color color) {
    _checkedItemIndex = index;
    _red = color.red;
    _green = color.green;
    _blue = color.blue;
    rController.text = _red.toString();
    gController.text = _green.toString();
    bController.text = _blue.toString();
  }

  /// 選択されている色のindexを取得
  /// * @return `int` : 選択されている色のindex
  int getCheckedItemIndex() {
    return _checkedItemIndex;
  }

  /// 色の変更
  /// * `index` : 選択されている色のindex
  /// * `color` : 現在のプライマリーカラー
  void changeCheckedItemIndex(int index, Color color) {
    _init(index, color);
    notifyListeners();
  }

  /* RGBEditor
   -----------------------------------------------------------*/

  /// RGBを編集
  /// * `r` : Red(0~255)
  /// * `g` : Green(0~255)
  /// * `b` : Blue(0~255)
  void editRGB({
    int? r,
    int? g,
    int? b,
  }) {
    if (r != null) _red = r;
    if (g != null) _green = g;
    if (b != null) _blue = b;
    notifyListeners();
  }

  /// 現在の色を取得
  /// * @return `Color` : 現在の色
  Color getColor() {
    return Color.fromARGB(255, _red, _green, _blue);
  }

  /// RGBエディタの値を確認
  /// * `controller` : TextEditingController
  /// * `value` : 現在フォームにあるデータ
  /// * `action` : 編集時の処理
  void checkEditorValue(
    TextEditingController controller,
    String value,
    Function(int) action,
  ) {
    if (RegExp(r'[^0-9]').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'[^0-9]'), "");
      controller.text = value;
      TextFieldCursor.moveCursor(controller);
    }
    if (RegExp(r'^0+[0-9]+').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'^0+'), "");
      controller.text = value;
      TextFieldCursor.moveCursor(controller);
    }

    int code = int.tryParse(value) ?? 0;
    if (code <= 0) {
      controller.text = "0";
      code = 0;
      TextFieldCursor.moveCursor(controller);
    }
    if (code > 255) {
      controller.text = "255";
      code = 255;
      TextFieldCursor.moveCursor(controller);
    }
    action(code);
  }
}
