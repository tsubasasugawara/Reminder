// ignore_for_file: prefer_final_fields

import 'package:reminder/model/db/notifications.dart';

class AddReminderModel {
  late int? id; //現在編集中のリマインダーのid

  // 編集前のデータ
  var _dataBeforeEditing = <String, dynamic>{
    Notifications.titleKey: null,
    Notifications.contentKey: null,
    Notifications.timeKey: DateTime.now().millisecondsSinceEpoch,
    Notifications.setAlarmKey: Notifications.alarmOn,
    Notifications.frequencyKey: 0,
  };

  // 編集中のデータ
  var _dataBeingEditing = <String, dynamic>{
    Notifications.titleKey: "",
    Notifications.contentKey: "",
    Notifications.timeKey: DateTime.now().millisecondsSinceEpoch,
    Notifications.setAlarmKey: Notifications.alarmOn,
    Notifications.frequencyKey: 0,
  };

  static int update = 0;
  static int insert = 1;

  AddReminderModel(
    int? _id,
    String? title,
    String? content,
    int? time,
    int? setAlarm,
    int? frequency,
  ) {
    id = _id;

    _dataBeforeEditing[Notifications.titleKey] = title;
    _dataBeforeEditing[Notifications.contentKey] = content;
    _dataBeforeEditing[Notifications.timeKey] = time;
    _dataBeforeEditing[Notifications.setAlarmKey] =
        setAlarm ?? Notifications.alarmOn;
    _dataBeforeEditing[Notifications.frequencyKey] =
        frequency ?? Notifications.notRepeating;

    _dataBeingEditing[Notifications.titleKey] = title ?? "";
    _dataBeingEditing[Notifications.contentKey] = content ?? "";
    _dataBeingEditing[Notifications.timeKey] =
        time ?? _dataBeingEditing[Notifications.timeKey];
    _dataBeingEditing[Notifications.setAlarmKey] =
        setAlarm ?? Notifications.alarmOn;
    _dataBeingEditing[Notifications.frequencyKey] =
        frequency ?? Notifications.notRepeating;
  }

  /*
   * データを編集
   * @param title : タイトル
   * @param content : メモ
   * @param time : 発火時間
   * @param setAlarm : アラームのオン・オフ
   */
  void editData({
    String? title,
    String? content,
    int? time,
    int? setAlarm,
    int? frequency,
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
    if (frequency != null) {
      _dataBeingEditing[Notifications.frequencyKey] = frequency;
    }
    return;
  }

  /*
   * 編集前のデータを取得
   * @return Map<String, dynamic> : 編集前のデータ
   */
  Map<String, dynamic> getBeforeEditingData() {
    return _dataBeforeEditing;
  }

  /*
   * 編集中のデータを取得
   * @return Map<String, dynamic> : 編集中のデータ
   */
  Map<String, dynamic> getBeingEditingData() {
    return _dataBeingEditing;
  }

  /*
   * 編集中のデータを上書き
   */
  void copyToBeforeEditingData() {
    _dataBeforeEditing = _dataBeingEditing;
  }

  /*
   * すでにデータが存在する場合は更新、そうでなければ追加
   * @return [id, status] : [追加または更新したデータのid, 追加(1)か更新(0)]
   */
  Future<List<int?>> updateOrInsert() async {
    var nt = Notifications();
    var title = _dataBeingEditing[Notifications.titleKey];
    var content = _dataBeingEditing[Notifications.contentKey];
    var time = _dataBeingEditing[Notifications.timeKey];
    var setAlarm = _dataBeingEditing[Notifications.setAlarmKey];
    var frequency = _dataBeingEditing[Notifications.frequencyKey];

    if (id != null) {
      var resId = await nt.update(
        title: title.replaceAll(RegExp(r'^ +'), ''),
        content: content.replaceAll(RegExp(r'^ +'), ''),
        frequency: frequency ?? 0,
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

    var resId = await nt.insert(
      title,
      content,
      frequency ?? 0,
      time,
      setAlarm,
      Notifications.inHome,
    );
    return [resId, insert];
  }
}
