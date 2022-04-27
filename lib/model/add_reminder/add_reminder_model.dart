// ignore_for_file: prefer_final_fields

import 'package:reminder/model/db/db.dart';

class AddReminderModel {
  late int? id;
  var _dataBeforeEditing = <String, dynamic>{
    NotificationsTable.titleKey: null,
    NotificationsTable.contentKey: null,
    NotificationsTable.timeKey: DateTime.now().millisecondsSinceEpoch,
    NotificationsTable.setAlarmKey: 1,
  };
  var _dataBeingEditing = <String, dynamic>{
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

    _dataBeforeEditing[NotificationsTable.titleKey] = title;
    _dataBeforeEditing[NotificationsTable.contentKey] = content;
    _dataBeforeEditing[NotificationsTable.timeKey] = time;
    _dataBeforeEditing[NotificationsTable.setAlarmKey] = setAlarm ?? 1;

    _dataBeingEditing[NotificationsTable.titleKey] = title ?? "";
    _dataBeingEditing[NotificationsTable.contentKey] = content ?? "";
    _dataBeingEditing[NotificationsTable.timeKey] =
        time ?? _dataBeingEditing[NotificationsTable.timeKey];
    _dataBeingEditing[NotificationsTable.setAlarmKey] = setAlarm ?? 1;
  }

  void editData({
    String? title,
    String? content,
    int? time,
    int? setAlarm,
  }) {
    if (title != null) {
      _dataBeingEditing[NotificationsTable.titleKey] = title;
    }
    if (content != null) {
      _dataBeingEditing[NotificationsTable.contentKey] = content;
    }
    if (time != null) {
      _dataBeingEditing[NotificationsTable.timeKey] = time;
    }
    if (setAlarm != null) {
      _dataBeingEditing[NotificationsTable.setAlarmKey] = setAlarm;
    }
    return;
  }

  Map<String, dynamic> getBeforeEditingData() {
    return _dataBeforeEditing;
  }

  Map<String, dynamic> getBeingEditingData() {
    return _dataBeingEditing;
  }

  void copyToBeforeEditingData() {
    _dataBeforeEditing = _dataBeingEditing;
  }

  Future<List<int?>> updateOrInsert() async {
    var nt = NotificationsTable();
    var title = _dataBeingEditing[NotificationsTable.titleKey];
    var content = _dataBeingEditing[NotificationsTable.contentKey];
    var time = _dataBeingEditing[NotificationsTable.timeKey];
    var setAlarm = _dataBeingEditing[NotificationsTable.setAlarmKey];

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
