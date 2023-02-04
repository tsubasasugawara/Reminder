import 'dart:convert';
import 'package:reminder/model/db/notifications.dart';

class HomeListModel {
  HomeListModel();

  /*
   * notificationsからデータを取得(複数)
   * @param columns : 取得したいカラムの指定。
   * @param where : WHERE句
   * @param orderBy : orderBy句
   */
  static Future<List<Map>?> select(
    List<Object?> columns, {
    String? where,
    String? orderBy,
  }) async {
    try {
      var nt = Notifications();
      var _dataList = await nt.select(
        columns,
        orderBy: orderBy,
        where: where,
      );

      if (_dataList == null) {
        return null;
      }

      var res = <Map<String, dynamic>>[];
      const JsonDecoder decoder = JsonDecoder();
      for (var item in _dataList) {
        Map<String, dynamic> map = decoder.convert(jsonEncode(item));
        res.add(map);
      }

      return res;
    } catch (e) {
      return null;
    }
  }
}
