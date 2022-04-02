import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/model/alarm.dart';
import 'package:reminder/model/db.dart';
import 'package:reminder/model/home_model.dart';
import 'package:reminder/values/strings.dart';

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
      res = AppStrings.notifiedMsg;
    } else {
      res = DateFormat("yyyy/MM/dd").add_Hm().format(dt);
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
