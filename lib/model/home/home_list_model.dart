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

  Future<List<Map>?> selectById(int id) async {
    try {
      var nt = NotificationsTable();
      var dataList = await nt.select(
        columns: ['title', 'content', 'time'],
        where: "id = ?",
        whereArgs: [id],
      );
      return dataList;
    } catch (e) {
      return null;
    }
  }
}
