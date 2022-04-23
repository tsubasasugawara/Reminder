import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class AlarmSwitchButtonProvider extends ChangeNotifier {
  AlarmSwitchButtonProvider(this.setAlarm);

  int setAlarm;

  Widget changeIcon(BuildContext context, Function() action) {
    if (setAlarm == 0) {
      return TextButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).backgroundColor,
          ),
          foregroundColor: MaterialStateProperty.all(
            Theme.of(context).hintColor,
          ),
        ),
        onPressed: () {
          _changeSetAlarm();
          action();
        },
        icon: const Icon(Icons.alarm_off),
        label: Text(AppLocalizations.of(context)!.setAlarmOff),
      );
    } else {
      return TextButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).backgroundColor,
          ),
          foregroundColor: MaterialStateProperty.all(
            Theme.of(context).primaryColor,
          ),
        ),
        onPressed: () {
          _changeSetAlarm();
          action();
        },
        icon: const Icon(Icons.alarm_on),
        label: Text(AppLocalizations.of(context)!.setAlarmOn),
      );
    }
  }

  void _changeSetAlarm() {
    setAlarm = 1 - setAlarm;
    notifyListeners();
  }
}
