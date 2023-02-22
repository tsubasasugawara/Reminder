import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/utils/text_field_cursor/text_field_cursor.dart';

import '../../../../model/db/notifications.dart';
import '../../../../multilingualization/app_localizations.dart';

final repeatingSettingProvider = StateNotifierProvider<RepeatingSettingProvider,
    RepeatingSettingProviderData>((ref) => RepeatingSettingProvider(null));

class RepeatingSettingProviderData {
  // TODO:listItemの初期化の仕方を変更
  late List<String> listItem;

  int days = 0; // 繰り返しの間隔(日数)を格納
  int option = Notifications.notRepeating; // 選択肢の中から選択した場合

  late TextEditingController controller; //間隔を指定するフォームのコントローラ

  RepeatingSettingProviderData({
    required this.listItem,
    required int days,
    required int option,
    TextEditingController? controller,
  }) {
    this.days = days > 0 ? days : 0;
    this.option = option < 0 ? option : 0;
    this.controller =
        controller ?? TextEditingController(text: this.days.toString());
  }

  RepeatingSettingProviderData copyWith({
    List<String>? listItem,
    int? days,
    int? option,
    TextEditingController? controller,
  }) {
    return RepeatingSettingProviderData(
      listItem: listItem ?? this.listItem,
      days: days ?? this.days,
      option: option ?? this.option,
      controller: controller ?? this.controller,
    );
  }
}

class RepeatingSettingProvider
    extends StateNotifier<RepeatingSettingProviderData> {
  RepeatingSettingProvider(int? days)
      : super(
          RepeatingSettingProviderData(
            listItem: [],
            days: days ?? 0,
            option: days ?? 0,
            controller: TextEditingController(
                text: days != null ? days.toString() : "0"),
          ),
        );

  /*
   * 繰り返しの間隔を変更したときの処理
   * @param value : TextFieldの値
   */
  void onChanged(String? value) {
    var res = _validate(value);
    state = state.copyWith(days: int.parse(value ?? "0"), controller: res);
  }

  // TODO:関数名
  void setDays(int? days) {
    if (days == null || days == 0) {
      state = state.copyWith(days: 0, option: Notifications.notRepeating);
    } else if (days < 0) {
      state = state.copyWith(days: 0, option: days);
    } else {
      state = state.copyWith(days: days, option: Notifications.custom);
    }
  }

  /*
   * 入力値を整形する
   * @param value : TextFieldの値
   */
  TextEditingController? _validate(String? value) {
    if (value == null) return null;

    if (RegExp(r'[^0-9]').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'[^0-9]'), "");
    }

    if (RegExp(r'^0+[0-9]+').hasMatch(value)) {
      value = value.replaceAll(RegExp(r'^0+'), '');
    }

    if (value == "") value = "0";

    var res = TextEditingController(text: value);
    TextFieldCursor.moveCursor(res);
    return res;
  }

  /*
   * 繰り返し間隔によって、ボタンに表示するメッセージを変更する
   * @param frequency:繰り返し間隔
   */
  static String buttonMsg(BuildContext context, int days, int option) {
    String buttonMsg;

    if (option == Notifications.everyday) {
      buttonMsg = AppLocalizations.of(context)!.everyday;
    } else if (option == Notifications.everyWeek) {
      buttonMsg = AppLocalizations.of(context)!.everyWeek;
    } else if (option == Notifications.everyMonth) {
      buttonMsg = AppLocalizations.of(context)!.everyMonth;
    } else if (option == Notifications.everyYear) {
      buttonMsg = AppLocalizations.of(context)!.everyYear;
    } else if (option == Notifications.custom && days > 0) {
      buttonMsg = days.toString() + " ";
      buttonMsg += days == 1
          ? AppLocalizations.of(context)!.day
          : AppLocalizations.of(context)!.days;
    } else {
      buttonMsg = AppLocalizations.of(context)!.notRepeat;
    }

    return buttonMsg;
  }
}
