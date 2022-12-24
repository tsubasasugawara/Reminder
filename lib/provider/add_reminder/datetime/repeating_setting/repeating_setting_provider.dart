import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

import '../../../../components/text_field_cursor/text_field_cursor.dart';

class RepeatingSettingProvider extends ChangeNotifier {
  static const custom = 0;
  static const everyday = -1;
  static const everyWeek = -2;
  static const everyMonth = -3;
  static const everyYear = -4;
  static const notRepeating = -5;

  late BuildContext context;
  late List<String> listItem;

  int days = 0; // 繰り返しの間隔(日数)を格納
  int option = 0; // 選択肢の中から選択した場合

  late TextEditingController controller; //間隔を指定するフォームのコントローラ

  RepeatingSettingProvider(this.context, int? _days) {
    listItem = [
      AppLocalizations.of(context)!.everyday,
      AppLocalizations.of(context)!.everyWeek,
      AppLocalizations.of(context)!.everyMonth,
      AppLocalizations.of(context)!.everyYear,
    ];

    controller = TextEditingController();
    controller.text = "0";
    setDays(_days);
  }

  /*
   * 繰り返しの間隔を設定する
   * @param days : 繰り返しの間隔 or デフォルトの選択肢(マイナス)
  */
  void setDays(int? days) {
    if (days == null) return;

    if (days >= 1) {
      this.days = days;
      option = 0;
    } else if (days < 0) {
      this.days = 0;
      option = days;
    } else {
      this.days = 0;
      option = 0;
    }

    notifyListeners();
  }

  /*
   * 繰り返しの間隔を変更したときの処理
   * @param value : TextFieldの値
   */
  void onChanged(String? value) {
    _validate(value);
    setDays(int.tryParse(controller.text));
  }

  /*
   * 入力値を整形する
   * @param value : TextFieldの値
   */
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
    if (value == "") {
      controller.text = "0";
      TextFieldCursor.moveCursor(controller);
    }
  }
}
