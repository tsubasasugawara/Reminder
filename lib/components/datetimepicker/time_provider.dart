import 'package:flutter/cupertino.dart';
import 'package:reminder/components/datetimepicker/time_model.dart';

class TimeProvider extends ChangeNotifier {
  late TimeModel model;

  /// コンストラクタ
  /// * `hour` : 時間の初期値
  /// * `minute` : 分数の初期値
  TimeProvider(int hour, int minute) {
    model = TimeModel(hour, minute);
  }

  /// 時間を変更する
  /// * `hour` : 時間
  /// * `minute` : 分数
  void changeTime(int hour, int minute) {
    model.hour = hour;
    model.minute = minute;
    notifyListeners();
  }
}
