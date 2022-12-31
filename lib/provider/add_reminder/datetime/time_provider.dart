import 'package:flutter/cupertino.dart';
import 'package:reminder/model/add_reminder/time_model.dart';

class TimeProvider extends ChangeNotifier {
  late TimeModel model;

  /*
   * コンストラクタ
   * @param hour : 時間の初期値
   * @param minute : 分数の初期値
   */
  TimeProvider(int hour, int minute) {
    model = TimeModel(hour, minute);
  }

  /*
   * 時間を変更する
   * @param hour : 時間
   * @param minute : 分数
   */
  void changeTime(int hour, int minute) {
    model.hour = hour;
    model.minute = minute;
    notifyListeners();
  }
}
