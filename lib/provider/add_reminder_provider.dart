import 'package:flutter/material.dart';
import 'package:reminder/model/add_reminder_model.dart';
import 'package:reminder/model/alarm.dart';

class AddReminderProvider {
  late AddReminderModel model;

// Operate TextFormField
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

// Meanig correct value or not.
  bool titleIsOk = true;
  bool timeIsOk = false;

  final textsize = 20.0;

  AddReminderProvider(int? id, String? title, String? content, int? time) {
    // Edited or New.
    if (id == null || id == 0) {
      model = AddReminderModel(null, null, null);
    } else {
      model = AddReminderModel(id, title, content);
    }
    model.dataBeforeEditing["time"] = time;

    init();

    titleController.text = model.dataBeforeEditing["title"] ?? "";
    contentController.text = model.dataBeforeEditing["content"] ?? "";
  }

// id = 0 : all reset.
  void init() {
    timeIsOk = true;
  }

  Future insertData(int? _id) async {
    var title = model.dataBeingEditing["title"];
    var content = model.dataBeingEditing["content"];
    var time = model.millisecondsFromEpoch;

    var id = await model.updateOrInsert(_id, time);
    if (id != null) {
      await Alarm.alarm(id, title, content, time, false);
      // notifyListeners();
    }
  }

  titleValidate() {
    titleIsOk = titleController.text != "" ? true : false;
  }

  timeValidate() {
    var diff =
        model.millisecondsFromEpoch - DateTime.now().millisecondsSinceEpoch;

    if (diff <= 0) {
      timeIsOk = false;
    } else {
      timeIsOk = true;
    }
  }

  saveBtn(BuildContext context) {
    titleValidate();
    timeValidate();

    if (!titleIsOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("please enter some text."),
          action: SnackBarAction(
            label: "hide",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }

    if (!timeIsOk) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please specify a future date and time."),
          action: SnackBarAction(
            label: "hide",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
      return;
    }

    insertData(model.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(model.id == null ? "Registered" : "Saved"),
        action: SnackBarAction(
          label: "hide",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    if (model.id == null) {
      init();
      titleController.clear();
      contentController.clear();
    }
  }
}
