import 'package:reminder/model/db/notifications.dart';

class ReminderAdditionModel {
  static const int update = 0;
  static const int insert = 1;

  /*
   * すでにデータが存在する場合は更新、そうでなければ追加
   * @return [id, status] : [追加または更新したデータのid, 追加(1)か更新(0)]
   */
  Future<List<int?>> updateOrInsert(
    int? id, {
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
