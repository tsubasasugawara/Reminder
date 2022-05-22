import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/home/home_list_model.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/selection_item_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';

class HomeProvider extends ChangeNotifier with SelectionItemProvider {
  HomeListModel model = HomeListModel();

  HomeProvider() {
    update();
  }

  Future<void> getData() async {
    var data = await model.select();
    if (data == null) return;

    model.dataList = data;
    changeSelectedItemsLen(length: model.dataList.length);
    notifyListeners();
  }

  Future<void> update() async {
    var nt = NotificationsTable();
    await nt.update(
      {NotificationsTable.setAlarmKey: 0},
      "${NotificationsTable.timeKey} <= ? and ${NotificationsTable.frequencyKey} == 0",
      [DateTime.now().millisecondsSinceEpoch],
      null,
    );
    getData();
  }

  String getString(int index, String key) {
    return model.dataList[index][key];
  }

  int getInt(int index, String key) {
    return model.dataList[index][key];
  }

  int getDataListLength() {
    return model.dataList.length;
  }

  String alarmOnOff(int index, BuildContext context) {
    int setAlarm = model.dataList[index]["set_alarm"];
    int milliseconds = model.dataList[index]['time'];

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

  Future<void> moveToAddView(BuildContext context, {int? index}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          if (index != null) {
            return AddReminderView(
              id: model.dataList[index]["id"],
              title: model.dataList[index]["title"],
              content: model.dataList[index]["content"],
              time: model.dataList[index]["time"],
              setAlarm: model.dataList[index]["set_alarm"],
            );
          }
          return AddReminderView();
        },
      ),
    );
    getData();
  }

  @override
  void updateOrChangeMode() {
    if (selectedItemsCnt <= 0) {
      changeMode(false);
    } else {
      notifyListeners();
    }
  }

  @override
  void changeMode(bool mode) {
    selectedMode = mode;
    changeSelectedItemsLen();
    notifyListeners();
  }
}
