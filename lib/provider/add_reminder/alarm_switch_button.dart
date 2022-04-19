import 'package:flutter/material.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/values/colors.dart';

class AlarmSwitchButtonProvider extends ChangeNotifier {
  AlarmSwitchButtonProvider(this.setAlarm);

  int setAlarm;

  Widget changeIcon(BuildContext context, Function() action) {
    if (setAlarm == 0) {
      return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            AppColors.backgroundColor,
          ),
          foregroundColor: MaterialStateProperty.all(
            AppColors.hintTextColor,
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
      return ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            AppColors.backgroundColor,
          ),
          foregroundColor: MaterialStateProperty.all(
            AppColors.mainColor,
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
