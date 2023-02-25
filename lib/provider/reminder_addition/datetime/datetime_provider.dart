import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reminder/view/reminder_addition/date_time_picker/date_time_picker.dart';

import '../../../utils/pair/pair.dart';

final dateTimeProvider = StateNotifierProvider<DateTimeProvider, DateTimeData>(
    (ref) => DateTimeProvider(DateTime.now()));

class DateTimeData {
  DateTime currentDateTime;
  DateTime editingDateTime;

  DateTimeData({
    required this.currentDateTime,
    required this.editingDateTime,
  });

  DateTimeData copyWith({
    DateTime? currentDateTime,
    DateTime? editingDateTime,
  }) {
    return DateTimeData(
      currentDateTime: currentDateTime ?? this.currentDateTime,
      editingDateTime: editingDateTime ?? this.editingDateTime,
    );
  }
}

class DateTimeProvider extends StateNotifier<DateTimeData> {
  DateTimeProvider(DateTime? currentDateTime)
      : super(DateTimeData(
          currentDateTime: currentDateTime ?? DateTime.now(),
          editingDateTime: currentDateTime ?? DateTime.now(),
        ));

  /*
   * 日時を選択
   * @param context : BuildContext
   */
  Future<Pair<DateTime, int?>?> selectDateTime(
    BuildContext context,
    String uiMode, {
    DateTime? dateTime,
  }) async {
    return await DateTimePicker().showDateTimePicker(
      context,
      uiMode,
      Theme.of(context).dialogBackgroundColor,
    );
  }

  void changeDateTime({DateTime? currentDateTime, DateTime? editingDateTime}) {
    state = state.copyWith(
      currentDateTime: currentDateTime,
      editingDateTime: editingDateTime,
    );
  }

  void saveDateTime() {
    state = state.copyWith(currentDateTime: state.editingDateTime);
  }

  void changeDate({int? year, int? month, int? day}) {
    DateTime editingDateTime = DateTime(
      year ?? state.editingDateTime.year,
      month ?? state.editingDateTime.month,
      day ?? state.editingDateTime.day,
      state.editingDateTime.hour,
      state.editingDateTime.minute,
    );

    state = state.copyWith(editingDateTime: editingDateTime);
  }

  void changeTime({int? hour, int? minute}) {
    DateTime editingDateTime = DateTime(
      state.editingDateTime.year,
      state.editingDateTime.month,
      state.editingDateTime.day,
      hour ?? state.editingDateTime.hour,
      minute ?? state.editingDateTime.minute,
    );
    state = state.copyWith(editingDateTime: editingDateTime);
  }

  /*
   * 日時を整形して文字列として返す
   * @param context : BuildContext
   * @return String : 整形した日時の文字列
   */
  String dateTimeFormat(String format) {
    return DateFormat(format).format(state.currentDateTime);
  }

  /*
   * 日時をミリ秒で返す
   * @return int : ミリ秒
   */
  int getMilliSecondsFromEpoch() {
    return state.editingDateTime.millisecondsSinceEpoch;
  }
}
