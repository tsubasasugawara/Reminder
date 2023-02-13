import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/model/db/notifications.dart';

final alarmSwhitchProvider =
    StateNotifierProvider<AlarmSwitchProvider, AlarmSwitchProviderData>(
        (ref) => AlarmSwitchProvider(Notifications.alarmOn));

class AlarmSwitchProviderData {
  late int setAlarm;

  AlarmSwitchProviderData({required this.setAlarm});

  AlarmSwitchProviderData copyWith({int? setAlarm}) {
    return AlarmSwitchProviderData(setAlarm: setAlarm ?? this.setAlarm);
  }
}

class AlarmSwitchProvider extends StateNotifier<AlarmSwitchProviderData> {
  AlarmSwitchProvider(int setAlarm)
      : super(AlarmSwitchProviderData(setAlarm: setAlarm));

  void changeAlarmOnOff(int setAlarm) {
    state = state.copyWith(setAlarm: setAlarm);
  }
}
