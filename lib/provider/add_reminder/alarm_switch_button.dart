import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class AlarmSwitchButtonProvider extends ChangeNotifier {
  AlarmSwitchButtonProvider(this.setAlarm);

  //アラームが設定されているか。1:on, 2:off
  int setAlarm;

  /*
   * オン・オフのアイコンを返す
   * @param context:BuildContext
   * @param action:アイコンを押したときの処理
   * @param isTrash : ごみ箱(true)にいるかホーム(false)にいるか
   * @return Widget:オン・オフのアイコン
   */
  Widget changeIcon(
    BuildContext context,
    Function() action, {
    bool isTrash = false,
  }) {
    if (isTrash) {
      return _textButtonIcon(
        context,
        Theme.of(context).hintColor,
        () {},
        Icons.alarm_off,
        AppLocalizations.of(context)!.setAlarmOff,
      );
    } else if (setAlarm == 0) {
      return _textButtonIcon(
        context,
        Theme.of(context).hintColor,
        () {
          _changeSetAlarm();
          action();
        },
        Icons.alarm_off,
        AppLocalizations.of(context)!.setAlarmOff,
      );
    } else {
      return _textButtonIcon(
        context,
        Theme.of(context).primaryColor,
        () {
          _changeSetAlarm();
          action();
        },
        Icons.alarm_on,
        AppLocalizations.of(context)!.setAlarmOn,
      );
    }
  }

  //アラームのオン・オフを変更
  void _changeSetAlarm() {
    setAlarm = 1 - setAlarm;
    notifyListeners();
  }

  /*
   * アイコンボタンを作成
   * @param context:BuildContext
   * @param foregroundColor:アイコンの色
   * @param action:アイコンを押したときの処理
   * @param icon:アイコン
   * @param label:アイコンの説明文
   * @return Widget:アイコンボタン
   */
  Widget _textButtonIcon(
    BuildContext context,
    Color foregroundColor,
    Function() action,
    IconData icon,
    String label,
  ) {
    return TextButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).bottomAppBarColor,
        ),
        foregroundColor: MaterialStateProperty.all(
          foregroundColor,
        ),
      ),
      onPressed: () {
        action();
      },
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
