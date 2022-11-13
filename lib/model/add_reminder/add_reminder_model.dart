// ignore_for_file: prefer_final_fields

import 'package:reminder/model/db/db.dart';

class AddReminderModel {
  /// 現在編集中のリマインダーのid
  late int? id;

  /// 編集前のデータ
  var _dataBeforeEditing = <String, dynamic>{
    Notifications.titleKey: null,
    Notifications.contentKey: null,
    Notifications.timeKey: DateTime.now().millisecondsSinceEpoch,
    Notifications.setAlarmKey: 1,
  };

  /// 編集中のデータ
  var _dataBeingEditing = <String, dynamic>{
    Notifications.titleKey: "",
    Notifications.contentKey: "",
    Notifications.timeKey: DateTime.now().millisecondsSinceEpoch,
    Notifications.setAlarmKey: 1,
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

    _dataBeforeEditing[Notifications.titleKey] = title;
    _dataBeforeEditing[Notifications.contentKey] = content;
    _dataBeforeEditing[Notifications.timeKey] = time;
    _dataBeforeEditing[Notifications.setAlarmKey] = setAlarm ?? 1;

    _dataBeingEditing[Notifications.titleKey] = title ?? "";
    _dataBeingEditing[Notifications.contentKey] = content ?? "";
    _dataBeingEditing[Notifications.timeKey] =
        time ?? _dataBeingEditing[Notifications.timeKey];
    _dataBeingEditing[Notifications.setAlarmKey] = setAlarm ?? 1;
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
      _dataBeingEditing[Notifications.titleKey] = title;
    }
    if (content != null) {
      _dataBeingEditing[Notifications.contentKey] = content;
    }
    if (time != null) {
      _dataBeingEditing[Notifications.timeKey] = time;
    }
    if (setAlarm != null) {
      _dataBeingEditing[Notifications.setAlarmKey] = setAlarm;
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
    var nt = Notifications();
    var title = _dataBeingEditing[Notifications.titleKey];
    var content = _dataBeingEditing[Notifications.contentKey];
    var time = _dataBeingEditing[Notifications.timeKey];
    var setAlarm = _dataBeingEditing[Notifications.setAlarmKey];

    if (id != null) {
      var resId = await nt.update(
        title: title.replaceAll(RegExp(r'^ +'), ''),
        content: content.replaceAll(RegExp(r'^ +'), ''),
        frequency: 0,
        time: time,
        setAlarm: setAlarm,
        where: '${Notifications.idKey} = ?',
        whereArgs: [id],
      );

      if (resId != null && resId >= 1) {
        return [id, update];
      } else {
        return [null, null];
      }
    }

    var resId = await nt.insert(title, content, 0, time, setAlarm, 0);
    return [resId, insert];
  }
}
