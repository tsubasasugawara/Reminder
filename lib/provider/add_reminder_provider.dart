import 'package:flutter/material.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/model/add_reminder_model.dart';
import 'package:reminder/model/alarm.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class AddReminderProvider {
  late AddReminderModel model;

// Operate TextFormField
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  FocusNode titleFocusNode = FocusNode();
  FocusNode contentFocusNode = FocusNode();

  bool fabVisible = false;

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

  void init() {
    timeIsOk = true;
  }

  Future insertData(int? _id) async {
    var title = model.dataBeingEditing["title"];
    var content = model.dataBeingEditing["content"];
    var time = model.dataBeingEditing['time'];
    var created = false;

    var res = await model.updateOrInsert(_id);
    var id = res[0];
    var status = res[1];

    if (id != null) {
      if (status == AddReminderModel.update) created = true;
      await Alarm.alarm(id, title, content, time, created);
    }
  }

  void titleValidate() {
    titleIsOk = titleController.text != "" ? true : false;
  }

  void timeValidate() {
    var diff =
        model.dataBeingEditing['time'] - DateTime.now().millisecondsSinceEpoch;

    if (diff <= 0) {
      timeIsOk = false;
    } else {
      timeIsOk = true;
    }
  }

  void saveBtn(BuildContext context) {
    titleValidate();
    timeValidate();

    if (!titleIsOk) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.titleError,
        ShowSnackBar.error,
      );
      return;
    }

    if (!timeIsOk) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.dateTimeError,
        ShowSnackBar.error,
      );
      return;
    }

    insertData(model.id);

    ShowSnackBar(
      context,
      model.id == null
          ? AppLocalizations.of(context)!.saved
          : AppLocalizations.of(context)!.edited,
      ShowSnackBar.successful,
    );

    if (model.id == null) {
      init();
      titleController.clear();
      contentController.clear();
    } else {
      dataBinding();
    }
  }

  void dataBinding() {
    model.dataBeforeEditing = model.dataBeingEditing;
  }
}
