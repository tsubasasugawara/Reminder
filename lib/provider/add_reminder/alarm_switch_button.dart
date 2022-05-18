import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class AlarmSwitchButtonProvider extends ChangeNotifier {
  AlarmSwitchButtonProvider(this.setAlarm);

  int setAlarm;

  Widget changeIcon(BuildContext context, Function() action) {
    if (setAlarm == 0) {
      return textButtonIcon(
        context,
        Theme.of(context).hintColor,
        action,
        Icons.alarm_off,
        AppLocalizations.of(context)!.setAlarmOff,
      );
    } else {
      return textButtonIcon(
        context,
        Theme.of(context).primaryColor,
        action,
        Icons.alarm_on,
        AppLocalizations.of(context)!.setAlarmOn,
      );
    }
  }

  void _changeSetAlarm() {
    setAlarm = 1 - setAlarm;
    notifyListeners();
  }

  Widget textButtonIcon(
    BuildContext context,
    Color foregroundColor,
    Function() action,
    IconData icon,
    String label,
  ) {
    return TextButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).backgroundColor,
        ),
        foregroundColor: MaterialStateProperty.all(
          foregroundColor,
        ),
      ),
      onPressed: () {
        _changeSetAlarm();
        action();
      },
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
