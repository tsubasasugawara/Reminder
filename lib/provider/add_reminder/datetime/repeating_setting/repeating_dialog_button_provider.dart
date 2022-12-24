import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/provider/add_reminder/datetime/repeating_setting/repeating_setting_provider.dart';

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
    if (_frequency == RepeatingSettingProvider.everyday) {
      buttonMsg = AppLocalizations.of(context)!.everyday;
    } else if (_frequency == RepeatingSettingProvider.everyWeek) {
      buttonMsg = AppLocalizations.of(context)!.everyWeek;
    } else if (_frequency == RepeatingSettingProvider.everyMonth) {
      buttonMsg = AppLocalizations.of(context)!.everyMonth;
    } else if (_frequency == RepeatingSettingProvider.everyYear) {
      buttonMsg = AppLocalizations.of(context)!.everyYear;
    } else if (_frequency != null &&
        _frequency! > RepeatingSettingProvider.custom) {
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
