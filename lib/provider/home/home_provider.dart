import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/home/home_list_model.dart';
import 'package:reminder/model/kotlin_method_calling/kotlin_method_calling.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';

class HomeProvider extends ChangeNotifier {
  HomeListModel model = HomeListModel();

  List selectedItems = [];
  bool selectedMode = false;
  int selectedItemsCnt = 0;

  HomeProvider() {
    update();
  }

  Future<void> getData() async {
    var data = await model.select();
    if (data == null) return;

    model.dataList = data;
    changeSelectedItemsLen();
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

/*  選択削除
 ----------------------------------------------------------------------------- */

  Future<bool> _deleteData(List<int> ids) async {
    var res = await NotificationsTable().multipleDelete(ids);
    if (res != null && res >= 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _deleteAlarm(
    int id,
    String title,
    String content,
    int time,
  ) async {
    await KotlinMethodCalling.deleteAlarm(id, title, content, time);
  }

  List<int> getSelectedIndex() {
    List<int> indexs = [];
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) indexs.add(i);
    }
    return indexs;
  }

  Future<void> deleteButton(BuildContext context) async {
    List<int> ids = [];
    for (var ele in getSelectedIndex()) {
      var data = model.dataList[ele];
      ids.add(data['id']);
      await _deleteAlarm(
          data['id'], data['title'], data['content'], data['time']);
    }
    var res = await _deleteData(ids);

    if (res) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.deletedAlarm,
        Theme.of(context).primaryColor,
      );
    }

    update();
  }

  void changeSelectedItemsLen() {
    selectedItems = List.filled(getDataListLength(), false);
  }

  void changeSelected(int index) {
    selectedItems[index] = !selectedItems[index];
    if (selectedItems[index]) {
      selectedItemsCnt++;
    } else {
      selectedItemsCnt--;
    }
    updateOrChangeMode();
  }

  void allSelect(bool select) {
    for (int i = 0; i < selectedItems.length; i++) {
      selectedItems[i] = select;
    }
    if (select) {
      selectedItemsCnt = selectedItems.length;
    } else {
      selectedItemsCnt = 0;
    }
    updateOrChangeMode();
  }

  void updateOrChangeMode() {
    if (selectedItemsCnt <= 0) {
      changeMode(false);
    } else {
      notifyListeners();
    }
  }

  void changeMode(bool mode) {
    selectedMode = mode;
    changeSelectedItemsLen();
    notifyListeners();
  }
}
