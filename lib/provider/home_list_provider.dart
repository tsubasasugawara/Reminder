import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/model/alarm.dart';
import 'package:reminder/model/db.dart';
import 'package:reminder/model/home_list_model.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class HomeListProvider extends ChangeNotifier {
  late HomeListModel model;

  HomeListProvider() {
    model = HomeListModel();
    getData();
  }

  Future<void> getData() async {
    var data = await model.select();
    if (data != null) {
      model.dataList = data;
      notifyListeners();
    }
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

  Future<void> deleteFromDbAndAlarm(int index, Function() action) async {
    var id = model.dataList[index]['id'];
    var data = await model.selectById(id);

    if (data == null) return;

    _deleteData(id);
    action();
    _deleteAlarm(id, data);

    return;
  }

  Future<void> _deleteData(int id) async {
    await NotificationsTable().delete(id);
  }

  Future<void> _deleteAlarm(int id, List<Map> data) async {
    await Alarm.deleteAlarm(
        id, data[0]['title'], data[0]['content'], data[0]['time']);
  }
}
