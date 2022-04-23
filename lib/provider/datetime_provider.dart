import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/components/datetimepicker/date_time_picker.dart';
import 'package:reminder/model/add_reminder/datetime_model.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class DateTimeProvider extends ChangeNotifier {
  late DateTimeModel model;

  DateTimeProvider(int time) {
    model = DateTimeModel(time);
    _init(time);
  }

  void _init(int? time) {
    var dt = time == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(time);
    model.year = dt.year;
    model.month = dt.month;
    model.day = dt.day;
    model.hour = dt.hour;
    model.minute = dt.minute;
  }

  Future selectDateTime(BuildContext context) async {
    var res = await DateTimePicker(
      DateTime(model.year, model.month, model.day, model.hour, model.minute),
    ).showDateTimePicker(
      context,
      Theme.of(context).dialogBackgroundColor,
      Theme.of(context).copyWith(
        colorScheme: ColorScheme.dark(
          primary: Theme.of(context).primaryColor,
          onSurface: Colors.white,
          onPrimary: Colors.white,
        ),
      ),
    );
    if (res != null) _setvalue(res);
    notifyListeners();
  }

  void _setvalue(DateTime dt) {
    model.year = dt.year;
    model.month = dt.month;
    model.day = dt.day;
    model.hour = dt.hour;
    model.minute = dt.minute;
  }

  String dateTimeFormat(BuildContext context) {
    return DateFormat(AppLocalizations.of(context)!.dateTimeFormat).format(
        DateTime(model.year, model.month, model.day, model.hour, model.minute));
  }

  int getMilliSecondsFromEpoch() {
    return DateTime(
            model.year, model.month, model.day, model.hour, model.minute)
        .millisecondsSinceEpoch;
  }
}
