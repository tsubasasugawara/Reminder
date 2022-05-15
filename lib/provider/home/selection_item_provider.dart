import 'package:flutter/cupertino.dart';

class SelectionItemProvider extends ChangeNotifier {
  List<bool> selectedItems = [];
  bool selectedMode = false;

  SelectionItemProvider(int len) {
    changeSelectedItemsLen(len);
  }

  List<int> getSelectedIndex() {
    List<int> indexs = [];
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) indexs.add(i);
    }
    return indexs;
  }

  void changeSelectedItemsLen(int len) {
    selectedItems = List.filled(len, false);
  }

  void changeSelected(int index) {
    selectedItems[index] = !selectedItems[index];
    if (getSelectedItemsNum() == 0) {
      changeMode(selectedItems.length);
    } else {
      notifyListeners();
    }
  }

  void allSelect(bool select) {
    for (int i = 0; i < selectedItems.length; i++) {
      selectedItems[i] = select;
    }
    if (getSelectedItemsNum() == 0) {
      changeMode(selectedItems.length);
    } else {
      notifyListeners();
    }
  }

  int getSelectedItemsNum() {
    int cnt = 0;
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) cnt++;
    }
    return cnt;
  }

  void changeMode(int len) {
    selectedMode = !selectedMode;
    changeSelectedItemsLen(len);
    notifyListeners();
  }
}
