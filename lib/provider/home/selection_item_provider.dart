import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/kotlin_method_calling/kotlin_method_calling.dart';

//アイテムの複数選択のためのクラス
class SelectionItemProvider {
  //アイテムが選択されているかどうかを格納
  List<bool> selectedItems = [];

  //true: アイテムを選択できる, false: 通常
  bool selectionMode = false;

  //選択したアイテムの数
  int selectedItemsCnt = 0;

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
    await KotlinMethodCalling.registAlarm(id, title, content, time, frequency);
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
    await KotlinMethodCalling.deleteAlarm(id, title, content, time, frequency);
  }

  /*
   * 選択されたアイテムのインデックスを取得
   * @return List<int>:インデックスのリスト
   */
  List<int> _getSelectedIndex() {
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
  ) async {
    List<int> ids = [];
    for (var i in _getSelectedIndex()) {
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
    bool trash,
  ) async {
    List<int> ids = [];
    for (var i in _getSelectedIndex()) {
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
      where: nt.createMultipleIDWhereClauses(ids),
      whereArgs: ids,
    );
    return _checkForOperation(res);
  }

  /*
   * selectedItemsの長さを変更
   * @param length:変更後の長さ
   */
  void changeSelectedItemsLen({int? length}) {
    selectedItems = List.filled(length ?? selectedItems.length, false);
    selectedItemsCnt = 0;
  }

  /*
   * アイテムの選択または解除
   * @param index:選択または解除したいアイテムのインデックス
   */
  void changeSelected(int index) {
    selectedItems[index] = !selectedItems[index];
    updateSelectedItemsCnt(selectedItems[index]);
    updateOrChangeMode();
  }

  /*
   * 全てを選択または解除
   * @param select:選択(true)か解除か(false)
   */
  void allSelectOrNot(bool select) {
    if (select && selectedItemsCnt < selectedItems.length) {
      selectedItemsCnt = selectedItems.length;
    } else {
      selectedItemsCnt = 0;
    }
    for (int i = 0; i < selectedItems.length; i++) {
      selectedItems[i] = select;
    }
    updateOrChangeMode();
  }

  //モード変更時やアイテムをタップしたときの画面更新
  void updateOrChangeMode() {}

  /*
   * 選択しているアイテムの数を更新
   * @param val:選択(true),解除(false)
   */
  void updateSelectedItemsCnt(bool val) {
    if (val) {
      selectedItemsCnt++;
    } else {
      selectedItemsCnt--;
    }
  }

  /*
   * モード変更
   * @param mode:アイテムを選択する(true),通常(false)
   */
  void changeMode(bool mode) {}
}
