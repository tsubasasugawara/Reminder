import 'package:flutter/services.dart';
import 'package:reminder/model/db/db_interface.dart';
import 'package:reminder/model/db/notifications.dart';
import 'package:reminder/model/db/tags.dart';

import '../kotlin_method_calling/kotlin_method_calling.dart';
import 'db_env.dart';

class NotificationsTags implements DBInterface {
  static const idKey = "notification_tag_id";
  static const tagIdKey = Tags.idKey;
  static const notificationIdKey = Notifications.idKey;
  static const createAtKey = DBEnv.createdAtKey;
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
        .invokeMethod("notifications_tags_select", {
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
    int tagId,
    int notificationId,
  ) async {
    var res = await const MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("notifications_tags_insert", {
      tagIdKey: tagId,
      notificationIdKey: notificationId,
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
    int? tagId,
    int? notificationId,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    var res = await const MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("notifications_tags_update", {
      tagIdKey: tagId,
      notificationIdKey: notificationId,
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
        .invokeMethod("notifications_tags_delete", {
      'where': where,
      'whereArgs': _createMapFromObjectList(whereArgs),
    });
    return res;
  }
}
