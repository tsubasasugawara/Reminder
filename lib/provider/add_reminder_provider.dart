import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reminder/model/add_reminder_model.dart';
import 'package:reminder/model/alarm.dart';

class AddReminderProvider extends ChangeNotifier {
  AddReminderModel model =
      AddReminderModel("", "", DateTime.now().millisecondsSinceEpoch);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  bool titleIsOk = true;

  bool timeIsOk = true;

  AddReminderProvider() {
    init();
  }

  void init() {
    var dt = DateTime.now();
    model = AddReminderModel("", "", DateTime.now().millisecondsSinceEpoch);

    model.title = "";
    model.content = "";

    model.year = dt.year;
    model.month = dt.month;
    model.day = dt.day;
    model.hour = dt.hour;
    model.minute = dt.minute;

    titleController.clear();
    contentController.clear();

    titleIsOk = true;
    timeIsOk = true;
    notifyListeners();
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

  Future<void> insertData() async {
    var title = model.title;
    var content = model.content;
    var time =
        DateTime(model.year, model.month, model.day, model.hour, model.minute)
                .millisecondsSinceEpoch -
            DateTime.now().millisecondsSinceEpoch;

    var id = await model.insert(time);

    if (id != null) {
      await Alarm.alarm(id, title, content, time, false);
    }
    notifyListeners();
  }

  titleValidate() {
    titleIsOk = titleController.text != "" ? true : false;
    notifyListeners();
  }

  timeValidate() {
    var diff =
        DateTime(model.year, model.month, model.day, model.hour, model.minute)
                .millisecondsSinceEpoch -
            DateTime.now().millisecondsSinceEpoch;
    if (diff <= 0) {
      timeIsOk = false;
    } else {
      timeIsOk = true;
    }
  }

  saveBtn(BuildContext context) {
    titleValidate();
    timeValidate();

    if (!timeIsOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please specify a future date and time."),
        ),
      );
    }

    if (!(timeIsOk && timeIsOk)) return;

    insertData();
    init();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reminder registered."),
      ),
    );
  }
}
