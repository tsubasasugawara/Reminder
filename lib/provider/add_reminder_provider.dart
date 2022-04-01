import 'package:flutter/material.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/model/add_reminder_model.dart';
import 'package:reminder/model/alarm.dart';
import 'package:reminder/values/strings.dart';

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
    model = AddReminderModel(id, title, content, time);

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

    var id = await model.updateOrInsert(_id);
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
      ShowSnackBar(
        context,
        AppStrings.titleError,
        ShowSnackBar.error,
      );
      return;
    }

    if (!timeIsOk) {
      ShowSnackBar(
        context,
        AppStrings.dateTimeError,
        ShowSnackBar.error,
      );
      return;
    }

    insertData(model.id);

    ShowSnackBar(
      context,
      model.id == null ? AppStrings.edited : AppStrings.saved,
      ShowSnackBar.successful,
    );

    if (model.id == null) {
      init();
      titleController.clear();
      contentController.clear();
    }
  }
}
