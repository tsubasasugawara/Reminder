import 'package:flutter/cupertino.dart';
import 'package:reminder/components/datetimepicker/time_model.dart';

class TimeProvider extends ChangeNotifier {
  late TimeModel model;

  TimeProvider(int hour, int minute) {
    model = TimeModel(hour, minute);
  }

  void changeTime(int hour, int minute) {
    model.hour = hour;
    model.minute = minute;
    notifyListeners();
  }
}
