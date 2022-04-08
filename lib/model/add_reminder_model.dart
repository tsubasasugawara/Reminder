import 'package:flutter/services.dart';
import 'package:reminder/model/db.dart';

class AddReminderModel {
  late int? id;
  var dataBeforeEditing = <String, dynamic>{
    "title": null,
    "content": null,
    "time": DateTime.now().millisecondsSinceEpoch,
    "setAlarm": 1,
  };
  // time : Time difference from now.
  var dataBeingEditing = <String, dynamic>{
    "title": "",
    "content": "",
    "time": DateTime.now().millisecondsSinceEpoch,
    "setAlarm": 1,
  };

  static int update = 0;
  static int insert = 1;

  var platform = const MethodChannel('com.sugawara.reminder/alarm');

  AddReminderModel(
      int? _id, String? title, String? content, int? time, int? setAlarm) {
    id = _id;

    dataBeforeEditing['title'] = title;
    dataBeforeEditing['content'] = content;
    dataBeforeEditing['time'] = time;
    dataBeforeEditing['setAlarm'] = setAlarm ?? 1;

    dataBeingEditing['title'] = title ?? "";
    dataBeingEditing['content'] = content ?? "";
    dataBeingEditing['time'] = time ?? dataBeingEditing['time'];
    dataBeingEditing['setAlarm'] = setAlarm ?? 1;
  }

  Future<List<int?>> updateOrInsert(int? _id) async {
    var nt = NotificationsTable();
    var title = dataBeingEditing['title'];
    var content = dataBeingEditing['content'];
    var time = dataBeingEditing['time'];
    var setAlarm = dataBeingEditing['setAlarm'];

    var num = 0;
    if (_id != null) {
      num = await nt.update(_id, title, content, 0, time, setAlarm) ?? 0;
      return [id, update];
    }

    if (num == 0) {
      var id = await nt.insert(title, content, 0, time, setAlarm);
      return [id, insert];
    }
    return [null, null];
  }
}
