import 'package:flutter/services.dart';
import 'package:reminder/model/kotlin_method_calling/kotlin_method_calling.dart';

class Notifications {
  static const dbName = "notifications";
  static const tableName = "notifications";
  static const idKey = "id";
  static const titleKey = "title";
  static const contentKey = "content";
  static const frequencyKey = "frequency";
  static const timeKey = "time";
  static const setAlarmKey = "set_alarm";
  static const deletedKey = "deleted";
  static const createdAtKey = "created_at";
  static const updatedAtKey = "updated_at";

  //並び替えの方式
  static const String asc = "ASC";
  static const String desc = "DESC";

  //ゴミ箱かホームのどちらにあるのか
  static const int inHome = 0;
  static const int inTrash = 1;

  //アラームのOn・Off
  static const int alarmOn = 1;
  static const int alarmOff = 0;

  /*
   * whereArgsに使う値をListからMapへ変換
   * @param list : Objectの配列
   * @return Map<String, String>?
   */
  Map<String, String>? _createMapFromObjectList(
    List<Object?>? list,
  ) {
    if (list == null) return null;

    var map = <String, String>{};
    for (int i = 0; i < list.length; i++) {
      map[i.toString()] = list[i].toString();
    }

    return map;
  }

  /*
   * IDによって複数のカラムを指定するwhere句を作成
   * @param ids : IDのリスト
   * @return プレースホルダを用いたwhere句
   */
  String createMultipleIDWhereClauses(List<int> ids) {
    var statement = ' $idKey IN(?';
    for (int i = 1; i < ids.length; i++) {
      statement = statement + ',?';
    }
    statement = statement + ')';

    return statement;
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
    var res = await MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("select", {
      'columns': _createMapFromObjectList(columns),
      'where': where,
      'whereArgs': _createMapFromObjectList(whereArgs),
      'groupBy': groupBy,
      'having': having,
      'orderBy': orderBy,
      'limit': limit,
    });
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
    var res = await MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("insert", {
      titleKey: title,
      contentKey: content,
      frequencyKey: frequency,
      timeKey: time,
      setAlarmKey: setAlarm,
      deletedKey: deleted,
    });
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
   * @param wherArgs : WHERE句のプレースホルダに入れる値
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
    var res = await MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("update", {
      titleKey: title,
      contentKey: content,
      frequencyKey: frequency,
      timeKey: time,
      setAlarmKey: setAlarm,
      deletedKey: deleted,
      where: where,
      whereArgs: _createMapFromObjectList(whereArgs),
    });
    return res;
  }

  /*
   * DELETE文
   * @param where : WHERE句
   * @param wherArgs : WHERE句のプレースホルダに入れる値
   * @return res : 削除した行数
   */
  Future<int?> delete(
    String? where,
    List<Object?>? whereArgs,
  ) async {
    var res = await MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("delete", {
      'where': where,
      'whereArgs': _createMapFromObjectList(whereArgs),
    });
    return res;
  }

  /*
   * idによる複数削除
   * @param ids : 削除したいデータのidリスト
   * @return int? : 削除した数
   */
  Future<int?> multipleDelete(List<int> ids) async {
    if (ids.isEmpty) return null;

    var where = createMultipleIDWhereClauses(ids);

    return await delete(where, ids);
  }
}
