import 'dart:convert';
import 'package:reminder/model/db/db.dart';

class HomeListModel {
  HomeListModel();

  /// データベースから取得したデータを格納
  List<Map> dataList = <Map>[];

  /// notificationsからデータを取得(複数)
  /// * `columns` : 取得したいカラムの指定。
  /// * `where` : WHERE句
  /// * `orderBy` : orderBy句
  Future<void> select(
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
        return;
      }

      var res = <Map<String, dynamic>>[];
      const JsonDecoder decoder = JsonDecoder();
      for (var item in _dataList) {
        Map<String, dynamic> map = decoder.convert(jsonEncode(item));
        res.add(map);
      }

      dataList = res;
    } catch (e) {
      return;
    }
  }
}
