import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/home/home_list_model.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/home/selection_item_provider.dart';
import 'package:reminder/view/add_reminder/add_reminder_view.dart';
import 'package:reminder/view/home/deletion_confirmation_dialog.dart';

class HomeProvider extends ChangeNotifier with SelectionItemProvider {
  HomeListModel model = HomeListModel();

  HomeProvider() {
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
      "${NotificationsTable.timeKey} <= ? and ${NotificationsTable.frequencyKey} == 0",
      [DateTime.now().millisecondsSinceEpoch],
      null,
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
  Future<void> moveToAddView(BuildContext context, {int? index}) async {
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
  Future<bool> deleteButton(
    BuildContext context,
  ) async {
    var res = await showDialog(
      context: context,
      builder: (context) => const DeletionConfirmationDialog(),
    ).then(
      (value) => value ?? false,
    );
    if (res) {
      res = await delete(context, model.dataList);
      update();
      allSelectOrNot(false);
    }
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
