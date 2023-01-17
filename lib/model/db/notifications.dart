import 'db.dart';

class Notifications {
  late final DB db;

  static const idKey = "notification_id";
  static const titleKey = "title";
  static const contentKey = "content";
  static const frequencyKey = "frequency";
  static const timeKey = "time";
  static const setAlarmKey = "set_alarm";
  static const deletedKey = "deleted";
  static const createdAtKey = DB.createdAtKey;
  static const updatedAtKey = DB.updatedAtKey;

  //ゴミ箱かホームのどちらにあるのか
  static const int inHome = 0;
  static const int inTrash = 1;

  //アラームのOn・Off
  static const int alarmOn = 1;
  static const int alarmOff = 0;

  //繰り返し間隔のオプション
  static const custom = 0;
  static const everyday = -1;
  static const everyWeek = -2;
  static const everyMonth = -3;
  static const everyYear = -4;
  static const notRepeating = -5;

  Notifications() {
    db = DB();
  }

  /*
   * SELECT文
   * @param columns : 取得したいカラムのリスト
   * @param where : WHERE句
   * @param whereArgs : WHERE句のプレースホルダに入れる値
   * @param groupBy : GROUP BY句
   * @param having : HAVING句
   * @param orderBy : ORDER BY句
   * @param limit : LIMIT句
   * @return res : 取得したデータベースのデータ
   */
  Future<List<Object?>?> select(
    List<Object?> columns, {
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
  }) async {
    var res = await db.select(
      "notifications_select",
      columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
    );
    return res;
  }

  /*
   * INSERT文
   * @param title : タイトル
   * @param content : メモ
   * @param frequency : 間隔
   * @param time : 発火時間
   * @param setAlarm : アラームのオン(1)オフ(0)
   * @param deleted : ごみ箱(1), ホーム(0)
   * @return res : 挿入した行数
   */
  Future<int?> insert(
    String title,
    String content,
    int frequency,
    int time,
    int setAlarm,
    int deleted,
  ) async {
    var res = await db.insert(
      "notifications_insert",
      {
        titleKey: title,
        contentKey: content,
        frequencyKey: frequency,
        timeKey: time,
        setAlarmKey: setAlarm,
        deletedKey: deleted,
      },
    );
    return res;
  }

  /*
   * UPDATE文
   * @param title : タイトル
   * @param content : メモ
   * @param frequency : 間隔
   * @param time : 発火時間
   * @param setAlarm : アラームのオン(1)オフ(0)
   * @param deleted : ごみ箱(1), ホーム(0)
   * @param where : WHERE句
   * @param whereArgs : WHERE句のプレースホルダに入れる値
   * @return res : 更新した行数
   */
  Future<int?> update({
    String? title,
    String? content,
    int? frequency,
    int? time,
    int? setAlarm,
    int? deleted,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    var res = await db.update(
      "notifications_update",
      map: {
        titleKey: title,
        contentKey: content,
        frequencyKey: frequency,
        timeKey: time,
        setAlarmKey: setAlarm,
        deletedKey: deleted,
      },
      where: where,
      whereArgs: whereArgs,
    );
    return res;
  }

  /*
   * DELETE文
   * @param where : WHERE句
   * @param whereArgs : WHERE句のプレースホルダに入れる値
   * @return res : 削除した行数
   */
  Future<int?> delete(
    String? where,
    List<Object?>? whereArgs,
  ) async {
    var res = await db.delete(
      "notifications_delete",
      where,
      whereArgs,
    );
    return res;
  }

  /*
   * idによる複数削除
   * @param ids : 削除したいデータのidリスト
   * @return int? : 削除した数
   */
  Future<int?> multipleDelete(List<int> ids) async {
    if (ids.isEmpty) return null;

    var where = DB.createMultipleIDWhereClauses(idKey, ids);

    return await delete(where, ids);
  }
}
