import 'package:flutter/material.dart';
import 'package:reminder/model/alarm.dart';
import 'package:reminder/model/db.dart';
import 'package:reminder/model/home_model.dart';

class HomeProvider extends ChangeNotifier {
  late HomeModel model;

  HomeProvider() {
    model = HomeModel();
  }

  Future getData() async {
    var data = await model.select();
    if (data != null) {
      model.dataList = data;
      notifyListeners();
    }
  }

  String dateTimeFormat(int milliseconds) {
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    var now = DateTime.now();

    var diff = dt.difference(now);

    String res = "";

    if (diff.inMilliseconds <= 0) {
      res = "notified";
    } else {
      var diffDay = diff.inDays;
      var diffHour = diff.inHours - diffDay * 24;
      var diffMinute = diff.inMinutes - diffDay * 24 * 24 - diffHour * 24;

      if (diffDay == 1) {
        res += "$diffDay day, ";
      } else {
        res += "$diffDay days, ";
      }

      if (diffHour == 1) {
        res += "$diffHour hour and ";
      } else {
        res += "$diffHour hours and ";
      }

      if (diffMinute == 1) {
        res += "$diffMinute minute later";
      } else {
        res += "$diffMinute minutes later";
      }
    }

    return res;
  }

  Future deleteData(int index) async {
    var id = model.dataList[index]['id'];
    var data = await model.selectById(id);

    if (data != null) {
      await NotificationsTable().delete(id);
      await Alarm.deleteAlarm(id, data[0]['title'], data[0]['content']);
    }

    notifyListeners();
  }
}
