import 'package:flutter/material.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/model/add_reminder/add_reminder_model.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/kotlin_method_calling/kotlin_method_calling.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class AddReminderProvider {
  late AddReminderModel _model;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  //ごみ箱のアイテムかどうか
  bool isTrash;

  //キーボードが表示されているかどうか
  bool isKeyboardShown = false;

  /*
   * コンストラクタ
   * @param id : ID
   * @param title : タイトル
   * @param content : メモ
   * @param time : 発火時間
   * @param setAlarm : アラームがオン(1)かオフ(0)か
   */
  AddReminderProvider(
    int? id,
    String? title,
    String? content,
    int? time,
    int? setAlarm,
    this.isTrash,
  ) {
    _model = AddReminderModel(id, title, content, time, setAlarm);

    var before = _model.getBeforeEditingData();

    titleController.text = before[Notifications.titleKey] ?? "";
    contentController.text = before[Notifications.contentKey] ?? "";
  }

  /*
   * 編集中のデータを一時的に保存する
   * @param title : タイトル
   * @param content : メモ
   * @param time : 発火時間
   * @param setAlarm : オン(1),オフ(0)
   */
  void setData({
    String? title,
    String? content,
    int? time,
    int? setAlarm,
  }) {
    _model.editData(
      title: title,
      content: content,
      time: time,
      setAlarm: setAlarm,
    );
  }

  /*
   * modelから編集中のデータを取得
   * @param key:データのキー値
   * @return dynamic:キーに格納されているデータ
   */
  dynamic getData(String key) {
    return _model.getBeingEditingData()[key];
  }

  /*
   * データベースに保存する
   * @return [id, status] : [保存したデータのID, 保存(1)か更新(0)か失敗(null)]
   */
  Future<List<int>?> _saveToDb() async {
    var res = await _model.updateOrInsert();
    var id = res[0];
    var status = res[1];

    if (id == null || status == null) {
      return null;
    } else {
      return [id, status];
    }
  }

  /*
   * アラームをスケジューリングする
   * @param id : リマインダーのID
   * @param status : 保存(1)か更新(0)
   * @param 更新の場合はアラームを削除してから登録しなおす
   */
  Future<void> _registerAlarm(int id, int status) async {
    var before = _model.getBeforeEditingData();
    var being = _model.getBeingEditingData();

    await KotlinMethodCalling.deleteAlarm(
      id,
      before[Notifications.titleKey] ?? being[Notifications.titleKey],
      before[Notifications.contentKey] ?? being[Notifications.contentKey],
      before[Notifications.timeKey] ?? being[Notifications.timeKey],
    );
    if (being[Notifications.setAlarmKey] == 0) return;

    await KotlinMethodCalling.registAlarm(
      id,
      being[Notifications.titleKey],
      being[Notifications.contentKey],
      being[Notifications.timeKey],
    );
  }

  /*
   * タイトルの確認
   * @return bool : 正常(true),異常(false)
   */
  bool _titleValidate() {
    String value = titleController.text.replaceAll(RegExp(r'^ +'), '');
    return value != "" ? true : false;
  }

  /*
   * 発火時間の確認
   * @return bool : 正常(true),異常(false)
   */
  bool _timeValidate() {
    var diff = _model.getBeingEditingData()[Notifications.timeKey] -
        DateTime.now().millisecondsSinceEpoch;

    if (diff <= 0) {
      return false;
    }
    return true;
  }

  /*
   * アラームがセットされているか確認
   * @return bool : オン(true),オフ(false)
   */
  bool _checkSettingAlarm(int num) {
    return num == 0 ? false : true;
  }

  /*
   * リマインダーを保存
   * @param context : BuildContext
   */
  Future<void> saveBtn(BuildContext context) async {
    if (_titleValidate() == false) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.titleError,
        Theme.of(context).errorColor,
      );
      return;
    }

    if (_checkSettingAlarm(
            _model.getBeingEditingData()[Notifications.setAlarmKey]) &&
        _timeValidate() == false) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.dateTimeError,
        Theme.of(context).errorColor,
      );
      return;
    }

    var res = await _saveToDb();
    if (res == null) return;

    _registerAlarm(res[0], res[1]);

    ShowSnackBar(
      context,
      _model.id == null
          ? AppLocalizations.of(context)!.saved
          : AppLocalizations.of(context)!.edited,
      Theme.of(context).primaryColor,
    );

    if (_model.id == null) {
      titleController.clear();
      contentController.clear();
    } else {
      _model.copyToBeforeEditingData();
    }
  }
}
