import 'package:flutter/material.dart';
import 'package:reminder/provider/reminder_addition/alarm_switch.dart';
import 'package:reminder/provider/reminder_addition/datetime/datetime_provider.dart';
import 'package:reminder/provider/reminder_addition/datetime/repeating_setting/repeating_setting_provider.dart';
import 'package:reminder/utils/snack_bar/snackbar.dart';
import 'package:reminder/model/reminder_addition/reminder_addition_model.dart';
import 'package:reminder/model/db/notifications.dart';
import 'package:reminder/model/platform/kotlin.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:riverpod_context/riverpod_context.dart';

class ReminderAdditionalProvider {
  int? id;

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
  ReminderAdditionalProvider(
    this.id,
    String? title,
    String? content,
    this.isTrash,
  ) {
    titleController.text = title ?? "";
    contentController.text = content ?? "";
  }

  /*
   * データベースに保存する
   * @return [id, status] : [保存したデータのID, 保存(1)か更新(0)か失敗(null)]
   */
  Future<List<int>?> _saveToDb({
    required String title,
    required String content,
    required int time,
    required int setAlarm,
    required int? frequency,
  }) async {
    var res = await ReminderAdditionModel().updateOrInsert(
      this.id,
      title: title,
      content: content,
      time: time,
      setAlarm: setAlarm,
      frequency: frequency,
    );
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
  Future<void> _registerAlarm(
    int id,
    int status, {
    required String title,
    String content = "",
    required int time,
    int frequency = Notifications.notRepeating,
    int? setAlarm,
  }) async {
    await Kotlin.deleteAlarm(id, title, content, time, frequency);
    if (setAlarm == null || setAlarm == 0) return;

    await Kotlin.registAlarm(id, title, content, time, frequency);
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
  bool _timeValidate(DateTime dt) {
    var diff =
        dt.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;

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
    return num == Notifications.alarmOff ? false : true;
  }

  /*
   * リマインダーを保存
   * @param context : BuildContext
   */
  Future<void> saveBtn(BuildContext context) async {
    var title = titleController.text;
    var content = contentController.text;
    var dateTime = context.read(dateTimeProvider).currentDateTime;
    var setAlarm = context.read(alarmSwhitchProvider).setAlarm;
    var days = context.read(repeatingSettingProvider).days;
    var option = context.read(repeatingSettingProvider).option;
    int frequency;
    if (days > 0) {
      frequency = days;
    } else {
      frequency = option;
    }

    if (_titleValidate() == false) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.titleError,
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    if (_checkSettingAlarm(setAlarm) && _timeValidate(dateTime) == false) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.dateTimeError,
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    // TODO:処理がわかりづらい
    var res = await _saveToDb(
      title: title,
      content: content,
      time: dateTime.millisecondsSinceEpoch,
      setAlarm: setAlarm,
      frequency: frequency,
    );
    if (res == null) return;

    _registerAlarm(
      res[0],
      res[1],
      title: title,
      content: content,
      time: dateTime.millisecondsSinceEpoch,
      setAlarm: setAlarm,
      frequency: frequency,
    );

    ShowSnackBar(
      context,
      id == null
          ? AppLocalizations.of(context)!.saved
          : AppLocalizations.of(context)!.edited,
      Theme.of(context).primaryColor,
    );

    if (id == null) {
      titleController.clear();
      contentController.clear();
    }
  }
}
