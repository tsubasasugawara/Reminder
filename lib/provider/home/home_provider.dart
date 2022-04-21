import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/model/alarm/alarm.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/home/home_list_model.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class HomeProvider extends ChangeNotifier {
  HomeListModel model = HomeListModel();

  HomeProvider() {
    update();
  }

  Future<void> getData() async {
    var data = await model.select();
    if (data == null) return;

    model.dataList = data;
    notifyListeners();
  }

  Future<void> update() async {
    var nt = NotificationsTable();
    await nt.update(
      {"set_alarm": 0},
      "time <= ?",
      [DateTime.now().millisecondsSinceEpoch],
      null,
    );
    getData();
  }

  String alarmOnOff(int setAlarm, int milliseconds, BuildContext context) {
    if (setAlarm == 1) {
      return dateTimeFormat(milliseconds, context);
    } else {
      return AppLocalizations.of(context)!.setAlarmOff;
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

  Future<bool> deleteFromDbAndAlarm(int index, Function() action) async {
    var id = model.dataList[index]['id'];
    var data = await model.selectById(id);

    if (data == null) return false;

    var res = await _deleteData(id);
    action();
    await _deleteAlarm(id, data);

    return res;
  }

  Future<bool> _deleteData(int id) async {
    var res = await NotificationsTable().delete(id);
    if (res != null && res >= 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _deleteAlarm(int id, List<Map> data) async {
    Alarm.deleteAlarm(
        id, data[0]['title'], data[0]['content'], data[0]['time']);
  }
}
