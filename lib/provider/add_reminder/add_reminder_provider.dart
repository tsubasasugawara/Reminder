import 'package:flutter/material.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/model/add_reminder/add_reminder_model.dart';
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

  AddReminderProvider(
      int? id, String? title, String? content, int? time, int? setAlarm) {
    // Edited or New.
    model = AddReminderModel(id, title, content, time, setAlarm);

    init();

    titleController.text = model.dataBeforeEditing["title"] ?? "";
    contentController.text = model.dataBeforeEditing["content"] ?? "";
  }

  void init() {
    timeIsOk = true;
  }

  Future<void> registerAlarm() async {
    var res = await model.updateOrInsert();
    var id = res[0];
    var status = res[1];

    if (id == null) return;

    if (model.dataBeingEditing["set_alarm"] == 0) {
      await Alarm.deleteAlarm(
        id,
        model.dataBeforeEditing["title"] ?? model.dataBeingEditing["title"],
        model.dataBeforeEditing["content"] ?? model.dataBeingEditing["content"],
        model.dataBeforeEditing['time'] ?? model.dataBeingEditing["time"],
      );
    } else {
      await Alarm.alarm(
        id,
        model.dataBeingEditing["title"],
        model.dataBeingEditing["content"],
        model.dataBeingEditing['time'],
        status == AddReminderModel.update ? true : false,
      );
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

  Future<void> saveBtn(BuildContext context) async {
    titleValidate();

    if (!titleIsOk) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.titleError,
        ShowSnackBar.error,
      );
      return;
    }

    if (model.dataBeingEditing["set_alarm"] == 1) {
      timeValidate();
      if (!timeIsOk) {
        ShowSnackBar(
          context,
          AppLocalizations.of(context)!.dateTimeError,
          ShowSnackBar.error,
        );
        return;
      }
    }

    registerAlarm();

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
      model.dataBeforeEditing = model.dataBeingEditing;
    }
  }
}
