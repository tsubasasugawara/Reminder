import 'package:flutter/services.dart';

import '../platform/kotlin.dart';

class DB {
  static const dbName = "reminder";

  //並び替えの方式
  static const String asc = "ASC";
  static const String desc = "DESC";

  static const createdAtKey = "created_at";
  static const updatedAtKey = "updated_at";

  /*
   * whereArgsに使う値をListからMapへ変換
   * @param list : Objectの配列
   * @return Map<String, String>?
   */
  static Map<String, String>? createMapFromObjectList(
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
  static String createMultipleIDWhereClauses(String idKey, List<int> ids) {
    var statement = ' $idKey IN(?';
    for (int i = 1; i < ids.length; i++) {
      statement = statement + ',?';
    }
    statement = statement + ')';

    return statement;
  }

  /*
   * SELECT文
   * @param method : 呼び出したいメソッド名
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
    String method,
    List<Object?> columns, {
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
  }) async {
    var res =
        await const MethodChannel(Kotlin.channelName).invokeMethod(method, {
      'columns': createMapFromObjectList(columns),
      'where': where,
      'whereArgs': createMapFromObjectList(whereArgs),
      'groupBy': groupBy,
      'having': having,
      'orderBy': orderBy,
      'limit': limit,
    });
    return res;
  }

  /*
   * INSERT文
   * @param method : 呼び出したいメソッド名
   * @param map : 挿入するデータの連想配列
   * @return res : 挿入した行数
   */
  Future<int?> insert(
    String method,
    Map<String, Object> map,
  ) async {
    var res =
        await const MethodChannel(Kotlin.channelName).invokeMethod(method, map);
    return res;
  }

  /*
   * UPDATE文
   * @param method : 呼び出したいメソッド名
   * @param map : データの連想配列
   * @param where : WHERE句
   * @param whereArgs : WHERE句のプレースホルダに入れる値
   * @return res : 更新した行数
   */
  Future<int?> update(
    String method, {
    Map<String, Object?>? map,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    if (map != null && where != null) {
      map['where'] = where;
    }
    if (map != null && whereArgs != null) {
      map['whereArgs'] = createMapFromObjectList(whereArgs);
    }

    var res =
        await const MethodChannel(Kotlin.channelName).invokeMethod(method, map);
    return res;
  }

  /*
   * DELETE文
   * @param method : 呼び出したいメソッド名
   * @param where : WHERE句
   * @param whereArgs : WHERE句のプレースホルダに入れる値
   * @return res : 削除した行数
   */
  Future<int?> delete(
    String method,
    String? where,
    List<Object?>? whereArgs,
  ) async {
    var res =
        await const MethodChannel(Kotlin.channelName).invokeMethod(method, {
      'where': where,
      'whereArgs': createMapFromObjectList(whereArgs),
    });
    return res;
  }
}
