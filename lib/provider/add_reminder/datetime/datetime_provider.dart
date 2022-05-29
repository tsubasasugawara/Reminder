import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/components/datetimepicker/date_time_picker.dart';
import 'package:reminder/model/add_reminder/datetime_model.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class DateTimeProvider extends ChangeNotifier {
  late DateTimeModel model;

  /// コンストラクタ
  /// * `time` : 時間の初期値(ミリ秒)
  DateTimeProvider(int? time) {
    model = DateTimeModel(time ?? DateTime.now().millisecondsSinceEpoch);
  }

  /// 日時を選択
  /// * `context` : BuildContext
  Future<void> selectDateTime(BuildContext context) async {
    var res = await DateTimePicker(
      model.createDateTime(),
    ).showDateTimePicker(
      context,
      Theme.of(context).dialogBackgroundColor,
    );
    if (res != null) model.changeDateTime(res);
    notifyListeners();
  }

  /// 日時を整形して文字列として返す
  /// * `context` : BuildContext
  /// * @return `String` : 整形した日時の文字列
  String dateTimeFormat(BuildContext context) {
    return DateFormat(AppLocalizations.of(context)!.dateTimeFormat).format(
      model.createDateTime(),
    );
  }

  /// 日時をミリ秒で返す
  /// * @return `int` : ミリ秒
  int getMilliSecondsFromEpoch() {
    return (model.createDateTime()).millisecondsSinceEpoch;
  }
}
