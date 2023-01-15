import 'db.dart';

class Tags {
  late final DB db;

  static const idKey = "tag_id";
  static const tagKey = "tag";
  static const createdAtKey = DB.createdAtKey;
  static const updatedAtKey = DB.updatedAtKey;

  Tags() {
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
      "tags_select",
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
   * @param tag : タグ名
   * @return res : 挿入した行数
   */
  Future<int?> insert(
    String tag,
  ) async {
    var res = await db.insert(
      "tags_insert",
      {tagKey: tag},
    );
    return res;
  }

  /*
   * UPDATE文
   * @param tag : タグ名
   * @param where : WHERE句
   * @param whereArgs : WHERE句のプレースホルダに入れる値
   * @return res : 更新した行数
   */
  Future<int?> update({
    String? tag,
    String? where,
    List<Object?>? whereArgs,
  }) async {
    var res = await db.update(
      "tags_update",
      map: {tagKey: tag},
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
      "tags_delete",
      where,
      whereArgs,
    );
    return res;
  }
}
