import 'package:flutter/services.dart';
import 'package:reminder/model/alarm/alarm.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/home/home_model.dart';

class HomeProvider {
  bool checkBoxVisible = false;

  HomeModel model = HomeModel();

  void resetCheckedList() {
    model.checkedList.forEach((key, value) {
      model.checkedList[key] = false;
    });
  }

  Future<void> delete() async {
    List<int> idList = [];
    model.checkedList.forEach((key, value) {
      if (model.checkedList[key]) {
        idList.add(key);
      }
    });

    var platform = const MethodChannel('com.sugawara.reminder/alarm');
    await platform.invokeMethod(
      "test",
      <String, dynamic>{
        'data': idList,
      },
    );

    // var nt = NotificationsTable();
    // var data = await nt.selectById(idList);
    // if (data == null) return;

    // await nt.deleteById(idList);

    // for (var i = 0; i < data.length; i++) {
    //   await Alarm.deleteAlarm(
    //       data[i]['id'], data[i]['title'], data[i]['content'], data[i]['time']);
    // }

    model.checkedList = {};
  }
}
