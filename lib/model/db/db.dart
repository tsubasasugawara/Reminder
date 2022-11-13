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

  /// whereArgsに使う値をListからMapへ変換
  /// * `list` : Objectの配列
  /// @return Map<String, String>?
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

  /// IDによって複数のカラムを指定するwhere句を作成
  /// * `ids` : IDのリスト
  /// * @return `プレースホルダを用いたwhere句
  String createMultipleIDWhereClauses(List<int> ids) {
    var statement = ' id IN(?';
    for (int i = 1; i < ids.length; i++) {
      statement = statement + ',?';
    }
    statement = statement + ')';

    return statement;
  }

  /// SELECT文
  ///
  /// * `columns` : 取得したいカラムのリスト
  /// * `where` : WHERE句
  /// * `whereArgs` : WHERE句のプレースホルダに入れる値
  /// * `groupBy` : GROUP BY句
  /// * `having` : HAVING句
  /// * `orderBy` : ORDER BY句
  /// * `limit` : LIMIT句
  ///
  /// * @return `res` : 取得したデータベースのデータ
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

  /// INSERT文
  ///
  /// * `title` : タイトル
  /// * `content` : メモ
  /// * `frequency` : 頻度
  /// * `time` : 発火時間
  /// * `setAlarm` : アラームのオン(1)オフ(0)
  /// * `deleted` : ごみ箱(1), ホーム(0)
  ///
  /// * @return `res` : 挿入した行数
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
      'title': title,
      'content': content,
      'frequency': frequency,
      'time': time,
      'setAlarm': setAlarm,
      'deleted': deleted,
    });
    return res;
  }

  /// UPDATE文
  ///
  /// * `title` : タイトル
  /// * `content` : メモ
  /// * `frequency` : 頻度
  /// * `time` : 発火時間
  /// * `setAlarm` : アラームのオン(1)オフ(0)
  /// * `deleted` : ごみ箱(1), ホーム(0)
  /// * `where` : WHERE句
  /// * `wherArgs` : WHERE句のプレースホルダに入れる値
  ///
  /// * @return `res` : 更新した行数
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
      'title': title,
      'content': content,
      'frequency': frequency,
      'time': time,
      'setAlarm': setAlarm,
      'deleted': deleted,
      'where': where,
      'whereArgs': _createMapFromObjectList(whereArgs),
    });
    return res;
  }

  /// DELETE文
  /// * `where` : WHERE句
  /// * `wherArgs` : WHERE句のプレースホルダに入れる値
  ///
  /// * @return `res` : 削除した行数
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

  /// idによる複数削除
  /// * `ids` : 削除したいデータのidリスト
  /// * @return `int?` : 削除した数
  Future<int?> multipleDelete(List<int> ids) async {
    if (ids.isEmpty) return null;

    var where = createMultipleIDWhereClauses(ids);

    return await delete(where, ids);
  }
}
