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
    var res = await NotificationsTable().deleteById(id);
    if (res != null && res >= 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _deleteAlarm(int id, List<Map> data) async {
    await KotlinMethodCalling.deleteAlarm(
        id, data[0]['title'], data[0]['content'], data[0]['time']);
  }

  Future<void> deleteButton(BuildContext context, int index) async {
    var res = await deleteFromDbAndAlarm(
      index,
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

  // Future<void> showEditor(
  //   BuildContext context, {
  //   int? id,
  //   String? title,
  //   String? content,
  //   int? time,
  //   int? setAlarm,
  // }) async {
  //   await showDialog(
  //     context: context,
  //     builder: (BuildContext context) => Center(
  //       child: Container(
  //         color: Colors.white,
  //         width: MediaQuery.of(context).size.width * 0.8,
  //         height: MediaQuery.of(context).size.height * 0.7,
  //       ),
  //     ),
  //   );
  //   return;
  // }
}
