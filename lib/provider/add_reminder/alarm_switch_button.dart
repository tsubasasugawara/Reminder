import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class AlarmSwitchButtonProvider extends ChangeNotifier {
  AlarmSwitchButtonProvider(this.setAlarm);

  /// アラームが設定されているか。1:on, 2:off
  int setAlarm;

  /// オン・オフのアイコンを返す
  /// * `context`:BuildContext
  /// * `action`:アイコンを押したときの処理
  /// * `isTrash` : ごみ箱(true)にいるかホーム(false)にいるか
  /// * @return `Widget`:オン・オフのアイコン
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

  /// アラームのオン・オフを変更
  void _changeSetAlarm() {
    setAlarm = 1 - setAlarm;
    notifyListeners();
  }

  /// アイコンボタンを作成
  /// * `context`:BuildContext
  /// * `foregroundColor`:アイコンの色
  /// * `action`:アイコンを押したときの処理
  /// * `icon`:アイコン
  /// * `label`:アイコンの説明文
  /// * @return `Widget`:アイコンボタン
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
