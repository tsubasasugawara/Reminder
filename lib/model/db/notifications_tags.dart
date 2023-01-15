import 'package:reminder/model/db/notifications.dart';
import 'package:reminder/model/db/tags.dart';

import 'db.dart';

class NotificationsTags {
  late final DB db;

  static const idKey = "notification_tag_id";
  static const tagIdKey = Tags.idKey;
  static const notificationIdKey = Notifications.idKey;
  static const createAtKey = DB.createdAtKey;
  static const updatedAtKey = DB.updatedAtKey;

  NotificationsTags() {
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
      "notifications_tags_select",
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
   * @param tagId : タグのID
   * @param notificationId : リマインダーのID
   * @return res : 挿入した行数
   */
  Future<int?> insert(
    int tagId,
    int notificationId,
  ) async {
    var res = await db.insert(
      "notifications_tags_insert",
      {
        tagIdKey: tagId,
        notificationIdKey: notificationId,
      },
    );
    return res;
  }

  /*
   * UPDATE文
   * @param tagId : タグのID
   * @param notificationId : リマインダーのID
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
    var res = await db.update(
      "notifications_tags_update",
      map: {
        tagIdKey: tagId,
        notificationIdKey: notificationId,
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
      "notifications_tags_delete",
      where,
      whereArgs,
    );
    return res;
  }
}
