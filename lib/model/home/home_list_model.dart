import 'dart:convert';
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
      var nt = Notifications();
      var dataList = await nt.select(
        ['id', 'title', 'content', 'time', 'set_alarm'],
        orderBy: 'id DESC',
        where: where,
      );

      if (dataList == null) {
        return null;
      }

      var res = <Map<String, dynamic>>[];
      const JsonDecoder decoder = JsonDecoder();
      for (var item in dataList) {
        Map<String, dynamic> map = decoder.convert(jsonEncode(item));
        res.add(map);
      }
      return res;
    } catch (e) {
      return null;
    }
  }
}
