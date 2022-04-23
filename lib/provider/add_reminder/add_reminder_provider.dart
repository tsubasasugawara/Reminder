import 'package:flutter/material.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/model/add_reminder/add_reminder_model.dart';
import 'package:reminder/model/alarm/alarm.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class AddReminderProvider {
  late AddReminderModel model;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool isKeyboardShown = false;

  final textsize = 20.0;

  AddReminderProvider(
      int? id, String? title, String? content, int? time, int? setAlarm) {
    // Edited or New.
    model = AddReminderModel(id, title, content, time, setAlarm);

    titleController.text =
        model.dataBeforeEditing[NotificationsTable.titleKey] ?? "";
    contentController.text =
        model.dataBeforeEditing[NotificationsTable.contentKey] ?? "";
  }

  void setInt(String key, bool before, int value) {
    if (before) {
      model.dataBeforeEditing[key] = value;
    } else {
      model.dataBeingEditing[key] = value;
    }
  }

  void setString(String key, bool before, String value) {
    if (before) {
      model.dataBeforeEditing[key] = value;
    } else {
      model.dataBeingEditing[key] = value;
    }
  }

  int getInt(String key, bool before) {
    if (before) {
      return model.dataBeforeEditing[key];
    } else {
      return model.dataBeingEditing[key];
    }
  }

  Future<List<int>?> saveToDb() async {
    var res = await model.updateOrInsert();
    var id = res[0];
    var status = res[1];

    if (id == null || status == null) {
      return null;
    } else {
      return [id, status];
    }
  }

  Future<void> registerAlarm(int id, int status) async {
    Alarm.deleteAlarm(
      id,
      model.dataBeforeEditing[NotificationsTable.titleKey] ??
          model.dataBeingEditing[NotificationsTable.titleKey],
      model.dataBeforeEditing[NotificationsTable.contentKey] ??
          model.dataBeingEditing[NotificationsTable.contentKey],
      model.dataBeforeEditing[NotificationsTable.timeKey] ??
          model.dataBeingEditing[NotificationsTable.timeKey],
    );
    if (model.dataBeingEditing[NotificationsTable.setAlarmKey] == 0) return;

    Alarm.alarm(
      id,
      model.dataBeingEditing[NotificationsTable.titleKey],
      model.dataBeingEditing[NotificationsTable.contentKey],
      model.dataBeingEditing[NotificationsTable.timeKey],
    );
  }

  bool _titleValidate() {
    return titleController.text != "" ? true : false;
  }

  bool _timeValidate() {
    var diff = model.dataBeingEditing[NotificationsTable.timeKey] -
        DateTime.now().millisecondsSinceEpoch;

    if (diff <= 0) {
      return false;
    }
    return true;
  }

  bool _checkSettingAlarm(int num) {
    return num == 0 ? false : true;
  }

  Future<void> saveBtn(BuildContext context) async {
    if (_titleValidate() == false) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.titleError,
        ShowSnackBar.error,
      );
      return;
    }

    if (_checkSettingAlarm(
            model.dataBeingEditing[NotificationsTable.setAlarmKey]) &&
        _timeValidate() == false) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.dateTimeError,
        ShowSnackBar.error,
      );
      return;
    }

    var res = await saveToDb();
    if (res == null) return;

    registerAlarm(res[0], res[1]);

    ShowSnackBar(
      context,
      model.id == null
          ? AppLocalizations.of(context)!.saved
          : AppLocalizations.of(context)!.edited,
      ShowSnackBar.successful,
    );

    if (model.id == null) {
      titleController.clear();
      contentController.clear();
    } else {
      model.dataBeforeEditing = model.dataBeingEditing;
    }
  }
}
