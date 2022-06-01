import 'package:reminder/model/db/db.dart';

class HomeListModel {
  HomeListModel(this.where);

  String where;

  /// データベースから取得したデータを格納
  List<Map> dataList = <Map>[];

  /// notificationsからデータを取得(複数)
  /// * @return `List<Map>?>` : id, title, content, time, set_alarmを取得
  Future<List<Map>?> select() async {
    try {
      var nt = NotificationsTable();
      var dataList = await nt.select(
        columns: ['id', 'title', 'content', 'time', 'set_alarm'],
        orderBy: 'id DESC',
        where: where,
      );
      return dataList;
    } catch (e) {
      return null;
    }
  }
}
