import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reminder/view/reminder_addition/date_time_picker/date_time_picker.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

import '../../../utils/pair/pair.dart';

final dateTimeProvider =
    StateNotifierProvider.autoDispose<DateTimeProvider, DateTimeData>(
        (ref) => DateTimeProvider(DateTime.now()));

class DateTimeData {
  DateTime dt;

  DateTimeData({required this.dt});

  DateTimeData copyWith({DateTime? dt}) {
    return DateTimeData(dt: dt ?? this.dt);
  }
}

class DateTimeProvider extends StateNotifier<DateTimeData> {
  DateTimeProvider(DateTime? dt)
      : super(DateTimeData(
          dt: dt ?? DateTime.now(),
        ));

  /*
   * 日時を選択
   * @param context : BuildContext
   */
  Future<Pair<DateTime, int?>?> selectDateTime(
    BuildContext context, {
    DateTime? dateTime,
  }) async {
    return await DateTimePicker().showDateTimePicker(
      context,
      Theme.of(context).dialogBackgroundColor,
    );
  }

  void changeDateTime({DateTime? dateTime, int? frequency}) {
    state = state.copyWith(dt: dateTime);
  }

  void changeDate({int? year, int? month, int? day}) {
    DateTime dt = DateTime(
      year ?? state.dt.year,
      month ?? state.dt.month,
      day ?? state.dt.day,
      state.dt.hour,
      state.dt.minute,
    );

    state = state.copyWith(dt: dt);
  }

  void changeTime({int? hour, int? minute}) {
    DateTime dt = DateTime(
      state.dt.year,
      state.dt.month,
      state.dt.day,
      hour ?? state.dt.hour,
      minute ?? state.dt.minute,
    );
    state = state.copyWith(dt: dt);
  }

  /*
   * 日時を整形して文字列として返す
   * @param context : BuildContext
   * @return String : 整形した日時の文字列
   */
  String dateTimeFormat(BuildContext context) {
    return DateFormat(AppLocalizations.of(context)!.dateTimeFormat).format(
      createDateTime(state.dt),
    );
  }

  /*
   * 日時をミリ秒で返す
   * @return int : ミリ秒
   */
  int getMilliSecondsFromEpoch() {
    return state.dt.millisecondsSinceEpoch;
  }

  /*
   * 現在保存されている日時情報を基にインスタンス化
   * @return DateTime : DateTimeインスタンス
   */
  DateTime createDateTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
  }
}
