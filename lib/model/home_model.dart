import 'package:reminder/model/db.dart';

class HomeModel {
  HomeModel();

  List<Map> dataList = <Map>[];

  Future<List<Map>?> select() async {
    try {
      var nt = NotificationsTable();
      var dataList = await nt.select(
        columns: ['id', 'title', 'time', 'notified'],
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
        columns: ['title', 'content'],
        where: "id = ?",
        whereArgs: [id],
      );
      return dataList;
    } catch (e) {
      return null;
    }
  }
}
