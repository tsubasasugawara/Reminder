import 'package:flutter/cupertino.dart';
import 'package:reminder/view/home/home_list.dart';
import 'package:reminder/view/setting/setting.view.dart';

class MainProvider extends ChangeNotifier {
  int index = 0;

  void changeIndex(int _index) {
    index = _index;
    notifyListeners();
  }

  Widget setWidget() {
    switch (index) {
      case 0:
        return const HomeList();
      case 1:
        return const SettingView();
      default:
        return const HomeList();
    }
  }
}
