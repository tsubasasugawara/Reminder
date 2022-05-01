import 'package:flutter/cupertino.dart';

class ColorPickerProvider extends ChangeNotifier {
  late int _checkedItemIndex;

  ColorPickerProvider(int checkedItemIndex) {
    _checkedItemIndex = checkedItemIndex;
  }

  int getCheckedItemIndex() {
    return _checkedItemIndex;
  }

  void changeCheckedItemIndex(int index) {
    _checkedItemIndex = index;
    notifyListeners();
  }
}
