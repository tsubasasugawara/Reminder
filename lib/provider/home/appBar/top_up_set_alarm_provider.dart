import 'package:flutter/material.dart';

class TopUpSetAlarmButtonProvider extends ChangeNotifier {
  late bool topUp;

  TopUpSetAlarmButtonProvider(this.topUp);

  void changeTopUp() {
    topUp = !topUp;
    notifyListeners();
  }
}
