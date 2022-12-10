import 'package:flutter/material.dart';

import '../../model/db/db.dart';

class SearchProvider extends ChangeNotifier {
  // データベースのデータを格納
  List<Map> dataList = <Map>[];
  List<Map> displayDataList = <Map>[];

  // 検索バーのcontrollerとfocusNode
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  // キーボードが表示されているかどうか
  bool isKeyboardShown = false;

  SearchProvider(this.dataList);

  // ignore: todo
  // TODO: 連続で文字を入力しているときに、調べ直すのではなく、すでに一文字目を調べたものから探す
  void search(String str) {
    displayDataList = <Map>[];
    if (str.isEmpty) {
      notifyListeners();
      return;
    }

    str = str.toLowerCase();

    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i][Notifications.titleKey].toLowerCase().contains(str)) {
        displayDataList.add(dataList[i]);
      }
    }

    notifyListeners();
  }
}
