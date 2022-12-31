import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

import '../../../../model/db/notifications.dart';

class RepeatingDialogButtonProvider extends ChangeNotifier {
  BuildContext context;
  int? _frequency;

  String buttonMsg = ""; // ボタンに表示するメッセージ

  RepeatingDialogButtonProvider(this.context, this._frequency) {
    changeButtonMsg(_frequency);
  }

  /*
   * 繰り返し間隔によって、ボタンに表示するメッセージを変更する
   * @param frequency:繰り返し間隔
   */
  void changeButtonMsg(int? frequency) {
    if (_frequency == Notifications.everyday) {
      buttonMsg = AppLocalizations.of(context)!.everyday;
    } else if (_frequency == Notifications.everyWeek) {
      buttonMsg = AppLocalizations.of(context)!.everyWeek;
    } else if (_frequency == Notifications.everyMonth) {
      buttonMsg = AppLocalizations.of(context)!.everyMonth;
    } else if (_frequency == Notifications.everyYear) {
      buttonMsg = AppLocalizations.of(context)!.everyYear;
    } else if (_frequency != null && _frequency! > Notifications.custom) {
      buttonMsg = _frequency.toString() + " ";
      buttonMsg += _frequency == 1
          ? AppLocalizations.of(context)!.day
          : AppLocalizations.of(context)!.days;
    } else {
      buttonMsg = AppLocalizations.of(context)!.notRepeat;
    }

    notifyListeners();
  }

  /*
   * frequencyを変更する
   * @param frequency:繰り返し間隔
   */
  void changeFrequency(int? frequency) {
    _frequency = frequency;
    changeButtonMsg(frequency);
  }
}
