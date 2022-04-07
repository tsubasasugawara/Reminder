import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/model/alarm/alarm.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/home/home_list_model.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class HomeListProvider extends ChangeNotifier {
  late HomeListModel model;

  HomeListProvider() {
    model = HomeListModel();
  }

  Future getData() async {
    var data = await model.select();
    if (data != null) {
      var tmp = <Map>[];
      for (var ele in data) {
        tmp.add(Map.of(ele));
      }
      model.dataList = tmp;
      notifyListeners();
    }
  }

  String dateTimeFormat(int milliseconds, BuildContext context) {
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    var now = DateTime.now();

    var diff = dt.difference(now);

    String res = "";

    if (diff.inMilliseconds <= 0) {
      res = AppLocalizations.of(context)!.notifiedMsg;
    } else {
      res = DateFormat(AppLocalizations.of(context)!.dateTimeFormat).format(dt);
    }

    return res;
  }

  Future deleteData(int index) async {
    var id = model.dataList[index]['id'];
    var data = await model.selectById(id);

    if (data != null) {
      await NotificationsTable().delete(id);
      await Alarm.deleteAlarm(
          id, data[0]['title'], data[0]['content'], data[0]['time']);
    }

    notifyListeners();
  }

  void checkBox(Map list, int id, value) {
    if (list[id] == null) {
      list.addEntries(
        [
          MapEntry(id, value),
        ],
      );
    } else {
      list[id] = value;
    }
  }
}
