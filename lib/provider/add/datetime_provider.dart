import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/model/add/datetime_model.dart';
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

  Future<bool> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(
          model.year, model.month, model.day, model.hour, model.minute),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              dialogBackgroundColor: Colors.black,
              colorScheme: const ColorScheme.dark(
                primary: Colors.green,
                onSurface: Colors.green,
                onPrimary: Colors.black,
              ),
            ),
            child: child!);
      },
    );
    if (picked != null) {
      model.year = picked.year;
      model.month = picked.month;
      model.day = picked.day;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: model.hour, minute: model.minute),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              dialogBackgroundColor: Colors.black,
              colorScheme: const ColorScheme.dark(
                primary: Colors.green,
                onSurface: Colors.green,
                onPrimary: Colors.black,
              ),
            ),
            child: child!);
      },
    );
    if (picked != null) {
      model.hour = picked.hour;
      model.minute = picked.minute;
      notifyListeners();
      return true;
    }
    return false;
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
