import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorPickerProvider extends ChangeNotifier {
  late int _checkedItemIndex;

  late int _red;
  late int _green;
  late int _blue;

  TextEditingController rController = TextEditingController();
  TextEditingController gController = TextEditingController();
  TextEditingController bController = TextEditingController();

  ColorPickerProvider(int checkedItemIndex, Color primaryColor) {
    _init(primaryColor, checkedItemIndex);
  }

  void _init(Color color, int index) {
    _checkedItemIndex = index;
    _red = color.red;
    _green = color.green;
    _blue = color.blue;
    rController.text = _red.toString();
    gController.text = _green.toString();
    bController.text = _blue.toString();
  }

  int getCheckedItemIndex() {
    return _checkedItemIndex;
  }

  void changeCheckedItemIndex(Color color, int index) {
    _init(color, index);
    notifyListeners();
  }

  void moveCursor(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  /* RGBEditor
   -----------------------------------------------------------*/

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

  Color getColor() {
    return Color.fromARGB(255, _red, _green, _blue);
  }

  void checkEditorValue(
      TextEditingController controller, String value, Function(int) action) {
    if (RegExp(r'[^0-9]').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'[^0-9]'), "");
      controller.text = value;
      moveCursor(controller);
    }
    if (RegExp(r'^0+[0-9]+').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'^0+'), '');
      controller.text = value;
      moveCursor(controller);
    }

    int code = int.tryParse(value) ?? 0;
    if (code <= 0) {
      controller.text = "0";
      code = 0;
      moveCursor(controller);
    }
    if (code > 255) {
      controller.text = "255";
      code = 255;
      moveCursor(controller);
    }
    action(code);
  }
}
