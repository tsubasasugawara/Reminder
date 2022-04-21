import 'package:flutter/cupertino.dart';
import 'package:reminder/view/home/home_view.dart';
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
        return HomeView(this);
      case 1:
        return SettingView(this);
      default:
        return HomeView(this);
    }
  }
}
