import 'package:flutter/material.dart';

import '../../../components/text_field_cursor/text_field_cursor.dart';
import '../../../model/db/db.dart';
import '../setting.dart';

class AutoDeleteProvider extends ChangeNotifier {
  final int defaultDate = 30;
  bool checkBoxCondition = false;
  int date = 0;

  TextEditingController controller = TextEditingController();

  AutoDeleteProvider();

  /// FutureBuilderで行う処理
  Future<void> init() async {
    checkBoxCondition = await Setting.getBool(Setting.onOffKey) ?? false;
    date = await Setting.getInt(Setting.dateUntilDeletedKey) ?? 0;

    controller.text = date.toString();

    // 日付を編集したときにnotifyListneresで更新すると、
    // カーソルがずれるため、ここで修正する
    TextFieldCursor.moveCursor(controller);
  }

  void reload() {
    notifyListeners();
  }

  /// チェックボックスの値を変更する
  /// * `value` : 変更後の値
  Future<void> onChangeCheckBox(bool? value) async {
    checkBoxCondition = value ?? false;
    await Setting.setBool(Setting.onOffKey, checkBoxCondition);
    reload();
  }

  /// 削除までの日数に負の数や数字以外が入力された時、それらを排除する
  /// * `value` : 入力値
  void _validate(String? value) {
    if (value == null) return;

    if (RegExp(r'[^0-9]').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'[^0-9]'), "");
      controller.text = value;
      TextFieldCursor.moveCursor(controller);
    }
    if (RegExp(r'^0+[0-9]+').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'^0+'), '');
      controller.text = value;
      TextFieldCursor.moveCursor(controller);
    }
  }

  /// フォームのテキストが更新されたときに行う処理
  /// * `value` : フォームの値
  Future<void> onChangeTextField(String? value) async {
    _validate(value);
    await Setting.setInt(
      Setting.dateUntilDeletedKey,
      int.tryParse(controller.text) ?? 0,
    );

    reload();
  }

  /// 削除までの日にちを過ぎたリマインダーを削除する
  static Future<void> deleteReminder() async {
    bool? autoDeleteOn = await Setting.getBool(Setting.onOffKey);
    if (autoDeleteOn == null || !autoDeleteOn) return;

    int? daysLater = await Setting.getInt(Setting.dateUntilDeletedKey);
    if (daysLater == null) return;

    int deleteDate = DateTime.now()
        .subtract(Duration(days: daysLater))
        .millisecondsSinceEpoch;
    String where =
        "${Notifications.timeKey} <= ? AND ${Notifications.deletedKey} = 1";
    await Notifications().delete(where, [deleteDate]);
  }
}
