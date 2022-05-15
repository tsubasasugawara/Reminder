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
  Future<bool> deleteFromDbAndAlarm(
    List<int> indexList,
    Function() action,
  ) async {
    List<int> ids = [];
    for (var ele in indexList) {
      ids.add(model.dataList[ele]['id']);
    }
    var data = await model.selectById(ids);

    if (data == null) return false;
    if (data.length != ids.length) return false;

    var res = await _deleteData(ids);
    await _deleteAlarm(ids, data);
    action();

    return res;
  }

  Future<bool> _deleteData(List<int> ids) async {
    var res = await NotificationsTable().multipleDelete(ids);
    if (res != null && res >= 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _deleteAlarm(List<int> ids, List<Map> data) async {
    for (int i = 0; i < ids.length; i++) {
      await KotlinMethodCalling.deleteAlarm(
          ids[i], data[i]['title'], data[i]['content'], data[i]['time']);
    }
  }

  List<int> getSelectedIndex() {
    List<int> indexs = [];
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) indexs.add(i);
    }
    return indexs;
  }

  Future<void> deleteButton(BuildContext context) async {
    var res = await deleteFromDbAndAlarm(
      getSelectedIndex(),
      () {
        getData();
      },
    );
    if (res) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.deletedAlarm,
        Theme.of(context).primaryColor,
      );
    }
    return;
  }

  void changeSelectedItemsLen() {
    selectedItems = List.filled(getDataListLength(), false);
  }

  void changeSelected(int index) {
    selectedItems[index] = !selectedItems[index];
    if (getSelectedItemsNum() == 0) {
      changeMode();
    } else {
      notifyListeners();
    }
  }

  void allSelect(bool select) {
    for (int i = 0; i < selectedItems.length; i++) {
      selectedItems[i] = select;
    }
    if (getSelectedItemsNum() == 0) {
      changeMode();
    } else {
      notifyListeners();
    }
  }

  int getSelectedItemsNum() {
    int cnt = 0;
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) cnt++;
    }
    return cnt;
  }

  void changeMode() {
    selectedMode = !selectedMode;
    changeSelectedItemsLen();
    notifyListeners();
  }
}
