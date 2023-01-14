import 'package:flutter/services.dart';
import 'package:reminder/model/db/db_interface.dart';

import '../kotlin_method_calling/kotlin_method_calling.dart';
import 'db_env.dart';

class Tags implements DBInterface {
  static const idKey = "tag_id";
  static const tagKey = "tag";
  static const createdAtKey = DBEnv.createdAtKey;
  static const updatedAtKey = DBEnv.updatedAtKey;

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
    var res = await const MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("tags_select", {
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
    String tag,
  ) async {
    var res = await const MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("tags_insert", {
      tagKey: tag,
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
   * @param whereArgs : WHERE句のプレースホルダに入れる値
   * @return res : 更新した行数
   */
  Future<int?> update({
    String? tag,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    var res = await const MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("tags_update", {
      tagKey: tag,
      'where': where,
      'whereArgs': _createMapFromObjectList(whereArgs),
    });
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
    var res = await const MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("tags_delete", {
      'where': where,
      'whereArgs': _createMapFromObjectList(whereArgs),
    });
    return res;
  }
}
