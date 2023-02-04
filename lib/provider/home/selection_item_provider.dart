import 'package:reminder/model/db/notifications.dart';
import 'package:reminder/model/platform/kotlin.dart';

import '../../model/db/db.dart';

// モードを変更したときにdataListをこのクラスに渡す

//アイテムの複数選択のためのクラス
class SelectionItemProvider {
  /*
   * データベースでの操作が正しく行われたか確認
   * @param num : 更新や削除した数
   * @return bool : 成功:true, 失敗:false
   */
  bool _checkForOperation(int? num) {
    if (num != null && num >= 1) {
      return true;
    } else {
      return false;
    }
  }

  /*
   * アラームを登録
   * @param id : ID
   * @param title : タイトル
   * @param content : メモ
   * @param time : 発火時間
   * @param frequency:繰り返し間隔
   */
  Future<void> setOnAlarm(
    int id,
    String title,
    String content,
    int time,
    int frequency,
  ) async {
    await Kotlin.registAlarm(id, title, content, time, frequency);
  }

  /*
   * スケジュールされたアラームを解除
   * @param id:アラームのID
   * @param title:アラームのタイトル
   * @param content:アラームのメモ
   * @param time:アラームが発火する時間
   * @param frequency:繰り返し間隔
   */
  Future<void> _setOffAlarm(
    int id,
    String title,
    String content,
    int time,
    int frequency,
  ) async {
    await Kotlin.deleteAlarm(id, title, content, time, frequency);
  }

  /*
   * 選択されたアイテムのインデックスを取得
   * @return List<int>:インデックスのリスト
   */
  List<int> _getSelectedIndex(List<bool> selectedItems) {
    List<int> indexs = [];
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) indexs.add(i);
    }
    return indexs;
  }

  /*
   * リマインダーを削除
   * @param dataList:データベースのデータ
   * @return bool : 処理が完了(true)したか
   */
  Future<bool> delete(
    List<Map<dynamic, dynamic>> dataList,
    List<bool> selectedItems,
  ) async {
    List<int> ids = [];
    for (var i in _getSelectedIndex(selectedItems)) {
      ids.add(dataList[i][Notifications.idKey]);
      await _setOffAlarm(
        dataList[i][Notifications.idKey],
        dataList[i][Notifications.titleKey],
        dataList[i][Notifications.contentKey],
        dataList[i][Notifications.timeKey],
        dataList[i][Notifications.frequencyKey],
      );
    }
    int? res = await Notifications().multipleDelete(ids);
    return _checkForOperation(res);
  }

  /*
   * リマインダーをごみ箱へ移動または復元
   * @param dataList:データベースのデータ
   * @param trash : ごみ箱へ移動(true)するか復元(false)するか
   * @return bool : 処理が完了(true)したか
   */
  Future<bool> trash(
    List<Map<dynamic, dynamic>> dataList,
    List<bool> selectedItems,
    bool trash,
  ) async {
    List<int> ids = [];
    for (var i in _getSelectedIndex(selectedItems)) {
      ids.add(dataList[i][Notifications.idKey]);
      await _setOffAlarm(
        dataList[i][Notifications.idKey],
        dataList[i][Notifications.titleKey],
        dataList[i][Notifications.contentKey],
        dataList[i][Notifications.timeKey],
        dataList[i][Notifications.frequencyKey],
      );
    }
    var nt = Notifications();
    int? res = await nt.update(
      setAlarm: 0,
      deleted: trash ? 1 : 0,
      where: DB.createMultipleIDWhereClauses(Notifications.idKey, ids),
      whereArgs: ids,
    );
    return _checkForOperation(res);
  }
}
