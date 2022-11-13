import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/kotlin_method_calling/kotlin_method_calling.dart';

/// アイテムの複数選択のためのクラス
class SelectionItemProvider {
  /// アイテムが選択されているかどうかを格納
  List<bool> selectedItems = [];

  /// true: アイテムを選択できる, false: 通常
  bool selectionMode = false;

  /// 選択したアイテムの数
  int selectedItemsCnt = 0;

  /// データベースでの操作が正しく行われたか確認
  /// * `num` : 更新や削除した数
  /// * @return `bool` : 成功:true, 失敗:false
  bool _checkForOperation(int? num) {
    if (num != null && num >= 1) {
      return true;
    } else {
      return false;
    }
  }

  /// アラームを登録
  /// * `id` : ID
  /// * `title` : タイトル
  /// * `content` : メモ
  /// * `time` : 発火時間
  Future<void> setOnAlarm(
    int id,
    String title,
    String content,
    int time,
  ) async {
    await KotlinMethodCalling.registAlarm(id, title, content, time);
  }

  /// スケジュールされたアラームを解除
  /// * `id`:アラームのID
  /// * `title`:アラームのタイトル
  /// * `content`:アラームのメモ
  /// * `time`:アラームが発火する時間
  Future<void> _setOffAlarm(
    int id,
    String title,
    String content,
    int time,
  ) async {
    await KotlinMethodCalling.deleteAlarm(id, title, content, time);
  }

  /// 選択されたアイテムのインデックスを取得
  /// * @return `List<int>`:インデックスのリスト
  List<int> _getSelectedIndex() {
    List<int> indexs = [];
    for (int i = 0; i < selectedItems.length; i++) {
      if (selectedItems[i]) indexs.add(i);
    }
    return indexs;
  }

  /// リマインダーを削除
  /// * `dataList`:データベースのデータ
  /// * @return `bool` : 処理が完了(true)したか
  Future<bool> delete(
    List<Map<dynamic, dynamic>> dataList,
  ) async {
    List<int> ids = [];
    for (var ele in _getSelectedIndex()) {
      ids.add(dataList[ele]['id']);
      await _setOffAlarm(
        dataList[ele]['id'],
        dataList[ele]['title'],
        dataList[ele]['content'],
        dataList[ele]['time'],
      );
    }
    int? res = await Notifications().multipleDelete(ids);
    return _checkForOperation(res);
  }

  /// リマインダーをごみ箱へ移動または復元
  /// * `dataList`:データベースのデータ
  /// * `trash` : ごみ箱へ移動(true)するか復元(false)するか
  /// * @return `bool` : 処理が完了(true)したか
  Future<bool> trash(
    List<Map<dynamic, dynamic>> dataList,
    bool trash,
  ) async {
    List<int> ids = [];
    for (var ele in _getSelectedIndex()) {
      ids.add(dataList[ele]['id']);
      _setOffAlarm(
        dataList[ele]['id'],
        dataList[ele]['title'],
        dataList[ele]['content'],
        dataList[ele]['time'],
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

  /// selectedItemsの長さを変更
  /// * `length`:変更後の長さ
  void changeSelectedItemsLen({int? length}) {
    selectedItems = List.filled(length ?? selectedItems.length, false);
    selectedItemsCnt = 0;
  }

  /// アイテムの選択または解除
  /// * `index`:選択または解除したいアイテムのインデックス
  void changeSelected(int index) {
    selectedItems[index] = !selectedItems[index];
    updateSelectedItemsCnt(selectedItems[index]);
    updateOrChangeMode();
  }

  /// 全てを選択または解除
  /// * `select`:選択(true)か解除か(false)
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

  /// モード変更時やアイテムをタップしたときの画面更新
  void updateOrChangeMode() {}

  /// 選択しているアイテムの数を更新
  /// * `val`:選択(true),解除(false)
  void updateSelectedItemsCnt(bool val) {
    if (val) {
      selectedItemsCnt++;
    } else {
      selectedItemsCnt--;
    }
  }

  /// モード変更
  /// * `mode`:アイテムを選択する(true),通常(false)
  void changeMode(bool mode) {}
}
