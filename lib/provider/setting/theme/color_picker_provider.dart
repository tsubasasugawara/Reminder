import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';

import '../../../utils/text_field_cursor/text_field_cursor.dart';

final colorPickerProvider =
    StateNotifierProvider<ColorPickerProvider, ColorPicker>(
  (ref) => ColorPickerProvider(
    ref.read(themeProvider).selectedIndex,
    ref.read(themeProvider).primaryColor,
  ),
);

class ColorPicker {
//選択している色のindex
  late int checkedItemIndex;

  //0~255
  late int red;
  late int green;
  late int blue;

  TextEditingController rController = TextEditingController();
  TextEditingController gController = TextEditingController();
  TextEditingController bController = TextEditingController();

  ColorPicker({
    required this.checkedItemIndex,
    required this.red,
    required this.green,
    required this.blue,
  }) {
    rController.text = red.toString();
    gController.text = green.toString();
    bController.text = blue.toString();
  }

  ColorPicker copyWith({
    int? checkedItemIndex,
    int? red,
    int? green,
    int? blue,
  }) {
    return ColorPicker(
      checkedItemIndex: checkedItemIndex ?? this.checkedItemIndex,
      red: red ?? this.red,
      green: green ?? this.green,
      blue: blue ?? this.blue,
    );
  }
}

class ColorPickerProvider extends StateNotifier<ColorPicker> {
  ColorPickerProvider(int checkedItemIndex, Color primaryColor)
      : super(ColorPicker(
          checkedItemIndex: checkedItemIndex,
          red: primaryColor.red,
          green: primaryColor.green,
          blue: primaryColor.blue,
        ));

  static const int custom = -1;

  /*
   * 選択されている色のindexを取得
   * @param @return int : 選択されている色のindex
   */
  int getCheckedItemIndex() {
    return state.checkedItemIndex;
  }

  /*
   * 色の変更
   * @param index : 選択されている色のindex
   * @param color : 現在のプライマリーカラー
   */
  void changeCheckedItemIndex(int index, Color color) {
    state = state.copyWith(
      checkedItemIndex: index,
      red: color.red,
      green: color.green,
      blue: color.blue,
    );
  }

  /* RGBEditor
   -----------------------------------------------------------*/

  /*
   * RGBを編集
   * @param r : Red(0~255)
   * @param g : Green(0~255)
   * @param b : Blue(0~255)
   */
  void editRGB({
    int? r,
    int? g,
    int? b,
  }) {
    state = state.copyWith(
      red: r,
      green: g,
      blue: b,
    );
  }

  /*
   * 現在の色を取得
   * @param @return Color : 現在の色
   */
  Color getColor() {
    return Color.fromARGB(255, state.red, state.green, state.blue);
  }

  /*
   * RGBエディタの値を確認
   * @param controller : TextEditingController
   * @param value : 現在フォームにあるデータ
   * @param action : 編集時の処理
   */
  void checkEditorValue(
    TextEditingController controller,
    String value,
    Function(int) action,
  ) {
    if (RegExp(r'[^0-9]').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'[^0-9]'), "");
      controller.text = value;
    }
    if (RegExp(r'^0+[0-9]+').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'^0+'), "");
      controller.text = value;
    }

    int code = int.tryParse(value) ?? 0;
    if (code <= 0) {
      controller.text = "0";
      code = 0;
    }
    if (code > 255) {
      controller.text = "255";
      code = 255;
    }

    TextFieldCursor.moveCursor(controller);
    action(code);
  }
}
