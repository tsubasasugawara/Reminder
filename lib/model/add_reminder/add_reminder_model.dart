import 'package:reminder/model/db/db.dart';

class AddReminderModel {
  late int? id;
  var dataBeforeEditing = <String, dynamic>{
    NotificationsTable.titleKey: null,
    NotificationsTable.contentKey: null,
    NotificationsTable.timeKey: DateTime.now().millisecondsSinceEpoch,
    NotificationsTable.setAlarmKey: 1,
  };
  // time : Time difference from now.
  var dataBeingEditing = <String, dynamic>{
    NotificationsTable.titleKey: "",
    NotificationsTable.contentKey: "",
    NotificationsTable.timeKey: DateTime.now().millisecondsSinceEpoch,
    NotificationsTable.setAlarmKey: 1,
  };

  static int update = 0;
  static int insert = 1;

  AddReminderModel(
      int? _id, String? title, String? content, int? time, int? setAlarm) {
    id = _id;

    dataBeforeEditing[NotificationsTable.titleKey] = title;
    dataBeforeEditing[NotificationsTable.contentKey] = content;
    dataBeforeEditing[NotificationsTable.timeKey] = time;
    dataBeforeEditing[NotificationsTable.setAlarmKey] = setAlarm ?? 1;

    dataBeingEditing[NotificationsTable.titleKey] = title ?? "";
    dataBeingEditing[NotificationsTable.contentKey] = content ?? "";
    dataBeingEditing[NotificationsTable.timeKey] =
        time ?? dataBeingEditing[NotificationsTable.timeKey];
    dataBeingEditing[NotificationsTable.setAlarmKey] = setAlarm ?? 1;
  }

  Future<List<int?>> updateOrInsert() async {
    var nt = NotificationsTable();
    var title = dataBeingEditing[NotificationsTable.titleKey];
    var content = dataBeingEditing[NotificationsTable.contentKey];
    var time = dataBeingEditing[NotificationsTable.timeKey];
    var setAlarm = dataBeingEditing[NotificationsTable.setAlarmKey];

    if (id != null) {
      var values = {
        NotificationsTable.titleKey: title,
        NotificationsTable.contentKey: content,
        NotificationsTable.frequencyKey: 0,
        NotificationsTable.timeKey: time,
        NotificationsTable.setAlarmKey: setAlarm
      };
      var resId = await nt.update(
          values, '${NotificationsTable.idKey} = ?', [id], null);

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
