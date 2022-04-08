import 'package:flutter/material.dart';

class AlarmSwitchButton extends ChangeNotifier {
  AlarmSwitchButton(this.setAlarm);

  int setAlarm;

  Widget changeIcon(Function() action) {
    if (setAlarm == 0) {
      return IconButton(
        onPressed: () {
          _changeSetAlarm();
          action();
        },
        icon: const Icon(Icons.alarm_off),
      );
    } else {
      return IconButton(
        onPressed: () {
          _changeSetAlarm();
          action();
        },
        icon: const Icon(Icons.alarm_on),
      );
    }
  }

  void _changeSetAlarm() {
    setAlarm = 1 - setAlarm;
    notifyListeners();
  }
}
