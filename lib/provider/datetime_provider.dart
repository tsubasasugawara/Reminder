import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/model/datetime_model.dart';

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

    // model = DateTimeModel(DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> selectDate(BuildContext context) async {
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
    }
  }

  Future<void> selectTime(BuildContext context) async {
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
    }
  }

  String dateFormat() {
    return DateFormat("yyyy/MM/dd").format(
        DateTime(model.year, model.month, model.day, model.hour, model.minute));
  }

  String timeFormat() {
    return DateFormat("HH:mm").format(
        DateTime(model.year, model.month, model.day, model.hour, model.minute));
  }

  int getMilliSecondsFromEpoch() {
    return DateTime(
            model.year, model.month, model.day, model.hour, model.minute)
        .millisecondsSinceEpoch;
  }
}
