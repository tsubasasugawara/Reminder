import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/text_field_cursor/text_field_cursor.dart';
import '../../../model/db/notifications.dart';
import '../setting.dart';

final autoDeletionProvider =
    StateNotifierProvider<AutoDeletionProvider, AutoDeletion>(
        (ref) => AutoDeletionProvider());

class AutoDeletion {
  final int defaultDate = 30;
  bool checkBoxCondition = false;
  int date = 0;

  TextEditingController controller = TextEditingController();

  AutoDeletion({
    this.checkBoxCondition = false,
    this.date = 0,
    TextEditingController? controller,
  }) {
    this.controller = controller ?? TextEditingController();
  }

  AutoDeletion copyWith({
    bool? checkBoxCondition,
    int? date,
    TextEditingController? controller,
  }) {
    return AutoDeletion(
      checkBoxCondition: checkBoxCondition ?? this.checkBoxCondition,
      date: date ?? this.date,
      controller: controller ?? this.controller,
    );
  }
}

class AutoDeletionProvider extends StateNotifier<AutoDeletion> {
  AutoDeletionProvider() : super(AutoDeletion());

  //FutureBuilderで行う処理
  Future<void> init() async {
    var checkBoxCondition = await Setting.getBool(Setting.onOffKey) ?? false;
    var date = await Setting.getInt(Setting.dateUntilDeletedKey) ?? 0;

    state.controller.text = date.toString();
    //日付を編集したときにnotifyListneresで更新すると、
    //カーソルがずれるため、ここで修正する
    TextFieldCursor.moveCursor(state.controller);

    state = state.copyWith(checkBoxCondition: checkBoxCondition, date: date);
  }

  /*
   * チェックボックスの値を変更する
   * @param value : 変更後の値
   */
  Future<void> onChangeCheckBox(bool? value) async {
    var checkBoxCondition = value ?? false;
    await Setting.setBool(Setting.onOffKey, checkBoxCondition);
    state = state.copyWith(checkBoxCondition: checkBoxCondition);
  }

  /*
   * 削除までの日数に負の数や数字以外が入力された時、それらを排除する
   * @param value : 入力値
   */
  String? _validate(String? value) {
    if (value == null || value == "") return null;

    if (RegExp(r'[^0-9]').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'[^0-9]'), "");
      return value;
    }
    if (RegExp(r'^0+[0-9]+').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'^0+'), '');
      return value;
    }
    return value;
  }

  /*
   * フォームのテキストが更新されたときに行う処理
   * @param value : フォームの値
   */
  Future<void> onChangeTextField(String? value) async {
    var validateValue = _validate(value);
    await Setting.setInt(
      Setting.dateUntilDeletedKey,
      int.tryParse(state.controller.text) ?? 0,
    );

    state.controller.text = validateValue ?? "0";
    TextFieldCursor.moveCursor(state.controller);
  }

  //削除までの日にちを過ぎたリマインダーを削除する
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
