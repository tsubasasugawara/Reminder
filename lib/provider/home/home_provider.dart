import 'package:flutter/material.dart';
import 'package:reminder/model/db/notifications.dart';
import 'package:reminder/model/home/home_list_model.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/selection_item_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';
import 'package:reminder/view/home/confirmation_dialog.dart';

import '../../model/db/db.dart';

class HomeProvider extends ChangeNotifier with SelectionItemProvider {
  late HomeListModel model;

  //完全削除
  static const int completeDeletion = 0;

  //ごみ箱へ
  static const int moveToTrash = 1;

  //復元
  static const int restoreFromTrash = 2;

  //ごみ箱(true)かホーム(false)
  late bool isTrash;

  //ソートに使用するカラム
  String orderBy = Notifications.createdAtKey;

  //昇順、降順の設定
  String sortBy = DB.asc;

  bool topup = false;

  //ソート条件をつけないときに取得するカラム
  final List<Object?> stdColumns = [
    Notifications.idKey,
    Notifications.titleKey,
    Notifications.contentKey,
    Notifications.timeKey,
    Notifications.setAlarmKey,
    Notifications.frequencyKey,
  ];

  HomeProvider(this.isTrash) {
    model = HomeListModel();
    update();
  }

  void setSortBy(String _orderBy, String _sortBy, bool _topup) {
    orderBy = _orderBy;
    sortBy = _sortBy;
    topup = _topup;
  }

  //データ一覧を取得し、modelに保存
  Future<void> setData() async {
    //もしカラムリストに含まれていなかったら追加する
    var columns = [...stdColumns];
    if (!stdColumns.contains(orderBy)) {
      columns = [...columns, orderBy];
    }

    await model.select(
      columns,
      where: isTrash
          ? '${Notifications.deletedKey} = 1'
          : '${Notifications.deletedKey} = 0',
      orderBy:
          '${topup ? '${Notifications.setAlarmKey} ${DB.desc}, ' : ''} $orderBy $sortBy',
    );
    changeSelectedItemsLen(length: model.dataList.length);
    notifyListeners();
  }

  //すでに発火しているアラームのsetAlarmをオフ(0)にする
  Future<void> update() async {
    var nt = Notifications();
    await nt.update(
      setAlarm: 0,
      where:
          "${Notifications.timeKey} <= ? and ${Notifications.frequencyKey} == 0 and ${Notifications.deletedKey} == 0",
      whereArgs: [DateTime.now().millisecondsSinceEpoch],
    );
    setData();
  }

  /*
   * modelから文字列を取得する
   * @param index:データのインデックス
   * @param key:データのキー
   * @return String:keyに格納されている文字列
   */
  String getString(int index, String key) {
    return model.dataList[index][key];
  }

  /*
   * modelから整数値を取得する
   * @param index:データのインデックス
   * @param key:データのキー
   * @return String:keyに格納されている整数値
   */
  int getInt(int index, String key) {
    return model.dataList[index][key];
  }

  /*
   * データの行数を取得
   * @return int:データの行数
   */
  int getDataListLength() {
    return model.dataList.length;
  }

  /*
   * リマインダー編集画面への遷移
   * @param context:BuildContext
   * @param index:選択されたリマインダーのインデックス
   * @param isTrash : ごみ箱(true)、ホーム(false)
   */
  Future<void> moveToAddView(
    BuildContext context, {
    int? index,
    bool isTrash = false,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          if (index != null) {
            return AddReminderView(
              id: model.dataList[index][Notifications.idKey],
              title: model.dataList[index][Notifications.titleKey],
              content: model.dataList[index][Notifications.contentKey],
              time: model.dataList[index][Notifications.timeKey],
              setAlarm: model.dataList[index][Notifications.setAlarmKey],
              frequency: model.dataList[index][Notifications.frequencyKey],
              isTrash: isTrash,
            );
          }
          return AddReminderView();
        },
      ),
    );
    setData();
  }

  /*
   * 削除確認ダイアログでOKの場合にアラームを削除
   * @param context
   * @param movement : 完全削除(0)かごみ箱(1)か復元(2)
   */
  Future<bool> deleteButton(
    BuildContext context,
    int movement,
  ) async {
    bool res = true;
    if (movement != HomeProvider.restoreFromTrash) {
      res = await showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          movement == HomeProvider.completeDeletion
              ? AppLocalizations.of(context)!.deletionConfirmationMsg
              : AppLocalizations.of(context)!.movingToTrashConfirmationMsg,
        ),
      ).then(
        (value) => value ?? false,
      );
    }
    if (!res) return res;

    switch (movement) {
      case HomeProvider.completeDeletion: //完全削除
        res = await delete(model.dataList);
        break;
      case HomeProvider.moveToTrash: //ごみ箱へ
        res = await trash(model.dataList, true);
        break;
      case HomeProvider.restoreFromTrash: //ごみ箱から復元
        res = await trash(model.dataList, false);
        break;
    }
    update();
    allSelectOrNot(false);
    return res;
  }

  @override
  void updateOrChangeMode() {
    if (selectedItemsCnt <= 0) {
      changeMode(false);
    } else {
      notifyListeners();
    }
  }

  @override
  void changeMode(bool mode) {
    selectionMode = mode;
    changeSelectedItemsLen();
    notifyListeners();
  }
}
