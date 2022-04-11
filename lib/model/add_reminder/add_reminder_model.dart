import 'package:reminder/model/db.dart';

class AddReminderModel {
  late int? id;
  var dataBeforeEditing = <String, dynamic>{
    "title": null,
    "content": null,
    "time": DateTime.now().millisecondsSinceEpoch,
    "set_alarm": 1,
  };
  // time : Time difference from now.
  var dataBeingEditing = <String, dynamic>{
    "title": "",
    "content": "",
    "time": DateTime.now().millisecondsSinceEpoch,
    "set_alarm": 1,
  };

  static int update = 0;
  static int insert = 1;

  AddReminderModel(
      int? _id, String? title, String? content, int? time, int? setAlarm) {
    id = _id;

    dataBeforeEditing['title'] = title;
    dataBeforeEditing['content'] = content;
    dataBeforeEditing['time'] = time;
    dataBeforeEditing['set_alarm'] = setAlarm ?? 1;

    dataBeingEditing['title'] = title ?? "";
    dataBeingEditing['content'] = content ?? "";
    dataBeingEditing['time'] = time ?? dataBeingEditing['time'];
    dataBeingEditing['set_alarm'] = setAlarm ?? 1;
  }

  Future<List<int?>> updateOrInsert() async {
    var nt = NotificationsTable();
    var title = dataBeingEditing['title'];
    var content = dataBeingEditing['content'];
    var time = dataBeingEditing['time'];
    var setAlarm = dataBeingEditing['set_alarm'];

    if (id != null) {
      var values = {
        "title": title,
        "content": content,
        "frequency": 0,
        "time": time,
        "set_alarm": setAlarm
      };
      var resId = await nt.update(values, 'id = ?', [id], null);

      if (resId != null && resId >= 1) {
        return [id, update];
      } else {
        return [null, null];
      }
    }

    var resId = await nt.insert(title, content, 0, time, setAlarm);
    return [resId, insert];
  }
}
