// ignore_for_file: prefer_final_fields

import 'package:reminder/model/db/db.dart';

class AddReminderModel {
  /// 現在編集中のリマインダーのid
  late int? id;

  /// 編集前のデータ
  var _dataBeforeEditing = <String, dynamic>{
    NotificationsTable.titleKey: null,
    NotificationsTable.contentKey: null,
    NotificationsTable.timeKey: DateTime.now().millisecondsSinceEpoch,
    NotificationsTable.setAlarmKey: 1,
  };

  /// 編集中のデータ
  var _dataBeingEditing = <String, dynamic>{
    NotificationsTable.titleKey: "",
    NotificationsTable.contentKey: "",
    NotificationsTable.timeKey: DateTime.now().millisecondsSinceEpoch,
    NotificationsTable.setAlarmKey: 1,
  };

  static int update = 0;
  static int insert = 1;

  AddReminderModel(
    int? _id,
    String? title,
    String? content,
    int? time,
    int? setAlarm,
  ) {
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

  /// データを編集
  /// * `title` : タイトル
  /// * `content` : メモ
  /// * `time` : 発火時間
  /// * `setAlarm` : アラームのオン・オフ
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

  /// 編集前のデータを取得
  /// * @return `Map<String, dynamic>` : 編集前のデータ
  Map<String, dynamic> getBeforeEditingData() {
    return _dataBeforeEditing;
  }

  /// 編集中のデータを取得
  /// * @return `Map<String, dynamic>` : 編集中のデータ
  Map<String, dynamic> getBeingEditingData() {
    return _dataBeingEditing;
  }

  /// 編集中のデータを上書き
  void copyToBeforeEditingData() {
    _dataBeforeEditing = _dataBeingEditing;
  }

  /// すでにデータが存在する場合は更新、そうでなければ追加
  /// * @return `[id, status]` : [追加または更新したデータのid, 追加(1)か更新(0)]
  Future<List<int?>> updateOrInsert() async {
    var nt = NotificationsTable();
    var title = _dataBeingEditing[NotificationsTable.titleKey];
    var content = _dataBeingEditing[NotificationsTable.contentKey];
    var time = _dataBeingEditing[NotificationsTable.timeKey];
    var setAlarm = _dataBeingEditing[NotificationsTable.setAlarmKey];

    if (id != null) {
      var values = {
        NotificationsTable.titleKey: title.replaceAll(RegExp(r'^ +'), ''),
        NotificationsTable.contentKey: content.replaceAll(RegExp(r'^ +'), ''),
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
