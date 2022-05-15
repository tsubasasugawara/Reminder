import 'package:reminder/model/db/db.dart';

class HomeListModel {
  HomeListModel();

  List<Map> dataList = <Map>[];

  Future<List<Map>?> select() async {
    try {
      var nt = NotificationsTable();
      var dataList = await nt.select(
        columns: ['id', 'title', 'content', 'time', 'set_alarm'],
        orderBy: 'id DESC',
      );
      return dataList;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map>?> selectById(List<int> ids) async {
    if (ids.isEmpty) return null;
    try {
      var nt = NotificationsTable();

      String where = "id IN (?";
      for (int i = 1; i < ids.length; i++) {
        where = where + ",?";
      }
      where = where + ")";

      var dataList = await nt.select(
        columns: ['title', 'content', 'time'],
        where: where,
        whereArgs: ids,
      );
      return dataList;
    } catch (e) {
      return null;
    }
  }
}
