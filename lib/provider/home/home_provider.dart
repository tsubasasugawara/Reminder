import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/home/home_list_model.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/selection_item_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';
import 'package:reminder/view/home/confirmation_dialog.dart';

class HomeProvider extends ChangeNotifier with SelectionItemProvider {
  late HomeListModel model;

  /// 完全削除
  static const int completeDeletion = 0;

  /// ごみ箱へ
  static const int moveToTrash = 1;

  /// 復元
  static const int restoreFromTrash = 2;

  /// ごみ箱(true)かホーム(false)
  late bool isTrash;

  HomeProvider(this.isTrash) {
    model = HomeListModel(isTrash ? "deleted = 1" : "deleted = 0");
    update();
  }

  /// データ一覧を取得し、modelに保存
  Future<void> getData() async {
    var data = await model.select();
    if (data == null) return;

    model.dataList = data;
    changeSelectedItemsLen(length: model.dataList.length);
    notifyListeners();
  }

  /// すでに発火しているアラームのset_alarmをオフ(0)にする
  Future<void> update() async {
    var nt = NotificationsTable();
    await nt.update(
      {NotificationsTable.setAlarmKey: 0},
      where:
          "${NotificationsTable.timeKey} <= ? and ${NotificationsTable.frequencyKey} == 0 and ${NotificationsTable.deletedKey} == 0",
      whereArgs: [DateTime.now().millisecondsSinceEpoch],
    );
    getData();
  }

  /// modelから文字列を取得する
  /// * `index`:データのインデックス
  /// * `key`:データのキー
  /// * @return `String`:keyに格納されている文字列
  String getString(int index, String key) {
    return model.dataList[index][key];
  }

  /// modelから整数値を取得する
  /// * `index`:データのインデックス
  /// * `key`:データのキー
  /// * @return `String`:keyに格納されている整数値
  int getInt(int index, String key) {
    return model.dataList[index][key];
  }

  /// データの行数を取得
  /// * @return `int`:データの行数
  int getDataListLength() {
    return model.dataList.length;
  }

  /// アラームがオン:時間の文字列,オフ:"オフ"を返す
  /// * `index`:オン・オフを確認する対称のデータのインデックス
  /// * `context`:BuildContext
  /// * @retrun `String`:オン:時間の文字列, オフ:オフ
  String alarmOnOff(int index, BuildContext context) {
    int setAlarm = model.dataList[index]["set_alarm"];
    int milliseconds = model.dataList[index]['time'];
    if (setAlarm == 1) {
      return _dateTimeFormat(milliseconds, context);
    } else {
      return AppLocalizations.of(context)!.setAlarmOff;
    }
  }

  /// 時間を整形し、文字列として返す
  /// * `milliseconds`:ミリ秒表現の時間
  /// * `context`:BuildContext
  /// * @return `String`:整形後の時間の文字列
  String _dateTimeFormat(int milliseconds, BuildContext context) {
    var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    var now = DateTime.now();

    var diff = dt.difference(now);

    if (diff.inMilliseconds <= 0) {
      return AppLocalizations.of(context)!.notifiedMsg;
    } else {
      return DateFormat(AppLocalizations.of(context)!.dateTimeFormat)
          .format(dt);
    }
  }

  /// リマインダー編集画面への遷移
  /// * `context`:BuildContext
  /// * `index`:選択されたリマインダーのインデックス
  /// * `isTrash` : ごみ箱(true)、ホーム(false)
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
              id: model.dataList[index]["id"],
              title: model.dataList[index]["title"],
              content: model.dataList[index]["content"],
              time: model.dataList[index]["time"],
              setAlarm: model.dataList[index]["set_alarm"],
              isTrash: isTrash,
            );
          }
          return AddReminderView();
        },
      ),
    );
    getData();
  }

  /// 削除確認ダイアログでOKの場合にアラームを削除
  /// * `context`
  /// * `movement` : 完全削除(0)かごみ箱(1)か復元(2)
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
                : AppLocalizations.of(context)!.movingToTrashConfirmationMsg),
      ).then(
        (value) => value ?? false,
      );
    }
    if (!res) return res;

    switch (movement) {
      case HomeProvider.completeDeletion: // 完全削除
        res = await delete(model.dataList);
        break;
      case HomeProvider.moveToTrash: // ごみ箱へ
        res = await trash(model.dataList, true);
        break;
      case HomeProvider.restoreFromTrash: // ごみ箱から復元
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
