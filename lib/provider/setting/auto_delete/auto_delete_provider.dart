import 'package:flutter/material.dart';

import '../../../model/db/db.dart';
import '../setting.dart';

class AutoDeleteProvider extends ChangeNotifier {
  final int defaultDate = 30;
  bool checkBoxCondition = false;
  int date = 0;

  TextEditingController controller = TextEditingController();

  AutoDeleteProvider();

  Future<void> init() async {
    checkBoxCondition = await Setting.getBool(Setting.onOffKey) ?? false;
    date = await Setting.getInt(Setting.dateUntilDeletedKey) ?? 0;

    controller.text = date.toString();
  }

  void reload() {
    notifyListeners();
  }

  Future<void> onChangeCheckBox(bool? value) async {
    checkBoxCondition = value ?? false;
    await Setting.setBool(Setting.onOffKey, checkBoxCondition);
    reload();
  }

  void _moveCursor(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  void _validate(String? value) {
    if (value == null) return;

    if (RegExp(r'[^0-9]').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'[^0-9]'), "");
      controller.text = value;
      _moveCursor(controller);
    }
    if (RegExp(r'^0+[0-9]+').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'^0+'), '');
      controller.text = value;
      _moveCursor(controller);
    }
  }

  Future<void> onChangeTextField(String? value) async {
    _validate(value);
    await Setting.setInt(
      Setting.dateUntilDeletedKey,
      int.tryParse(controller.text) ?? 0,
    );
  }

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
