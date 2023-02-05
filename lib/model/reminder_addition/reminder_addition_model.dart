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

  static const int update = 0;
  static const int insert = 1;

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
  }

  /*
   * 編集前のデータを取得
   * @return Map<String, dynamic> : 編集前のデータ
   */
  Map<String, dynamic> getBeforeEditingData() {
    return _dataBeforeEditing;
  }

  void changeBeforeEditingData({
    String? title,
    String? content,
    int? time,
    int? setAlarm,
    int? frequency,
  }) {
    _dataBeforeEditing = <String, dynamic>{
      Notifications.titleKey:
          title ?? _dataBeforeEditing[Notifications.titleKey],
      Notifications.contentKey:
          content ?? _dataBeforeEditing[Notifications.contentKey],
      Notifications.timeKey: time ?? _dataBeforeEditing[Notifications.timeKey],
      Notifications.setAlarmKey:
          setAlarm ?? _dataBeforeEditing[Notifications.setAlarmKey],
      Notifications.frequencyKey:
          frequency ?? _dataBeforeEditing[Notifications.frequencyKey],
    };
  }

  /*
   * すでにデータが存在する場合は更新、そうでなければ追加
   * @return [id, status] : [追加または更新したデータのid, 追加(1)か更新(0)]
   */
  Future<List<int?>> updateOrInsert({
    required String title,
    required String content,
    required int time,
    required int setAlarm,
    required int? frequency,
  }) async {
    var nt = Notifications();

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
