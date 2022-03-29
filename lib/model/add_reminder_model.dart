import 'package:flutter/services.dart';
import 'package:reminder/model/db.dart';

class AddReminderModel {
  late int? id;
  var dataBeforeEditing = <String, dynamic>{};
  // time : Time difference from now.
  var dataBeingEditing = <String, dynamic>{
    "title": "",
    "content": "",
  };

  var millisecondsFromEpoch = DateTime.now().millisecondsSinceEpoch;

  var platform = const MethodChannel('com.sugawara.reminder/alarm');

  AddReminderModel(
    int? _id,
    String? title,
    String? content,
  ) {
    id = _id;

    dataBeforeEditing['title'] = title;
    dataBeforeEditing['content'] = content;

    dataBeingEditing['title'] = title ?? "";
    dataBeingEditing['content'] = content ?? "";
  }

  Future<int?> updateOrInsert(int? _id, int time) async {
    var nt = NotificationsTable();
    var title = dataBeingEditing['title'];
    var content = dataBeingEditing['content'];

    var num = 0;
    if (_id != null) {
      num = await nt.update(_id, title, content, 0, time, 0) ?? 0;
      return id;
    }

    if (num == 0) {
      var id = await nt.insert(
          dataBeingEditing['title'], dataBeingEditing['content'], 0, time);
      return id;
    }
    return null;
  }
}
