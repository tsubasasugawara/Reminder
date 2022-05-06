import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/components/brightness.dart';
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
    model.changeDateTimeVariables(dt);
  }

  Future selectDateTime(BuildContext context) async {
    var res = await DateTimePicker(
      model.createDateTime(),
    ).showDateTimePicker(
      context,
      Theme.of(context).dialogBackgroundColor,
    );
    if (res != null) model.changeDateTimeVariables(res);
    notifyListeners();
  }

  String dateTimeFormat(BuildContext context) {
    return DateFormat(AppLocalizations.of(context)!.dateTimeFormat).format(
      model.createDateTime(),
    );
  }

  int getMilliSecondsFromEpoch() {
    return (model.createDateTime()).millisecondsSinceEpoch;
  }
}
