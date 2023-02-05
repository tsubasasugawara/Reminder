import 'package:flutter_riverpod/flutter_riverpod.dart';

final alarmSwhitchProvider = StateNotifierProvider.autoDispose<
    AlarmSwitchProvider,
    AlarmSwitchProviderData>((ref) => AlarmSwitchProvider(1));

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
