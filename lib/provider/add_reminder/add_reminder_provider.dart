import 'package:flutter/material.dart';
import 'package:reminder/components/snack_bar/snackbar.dart';
import 'package:reminder/model/add_reminder/add_reminder_model.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/model/kotlin_method_calling/kotlin_method_calling.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

class AddReminderProvider {
  late AddReminderModel _model;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool isKeyboardShown = false;

  AddReminderProvider(
      int? id, String? title, String? content, int? time, int? setAlarm) {
    // Edited or New.
    _model = AddReminderModel(id, title, content, time, setAlarm);

    var before = _model.getBeforeEditingData();

    titleController.text = before[NotificationsTable.titleKey] ?? "";
    contentController.text = before[NotificationsTable.contentKey] ?? "";
  }

  void setData({
    String? title,
    String? content,
    int? time,
    int? setAlarm,
  }) {
    _model.editData(
      title: title,
      content: content,
      time: time,
      setAlarm: setAlarm,
    );
  }

  dynamic getData(String key) {
    return _model.getBeingEditingData()[key];
  }

  Future<List<int>?> saveToDb() async {
    var res = await _model.updateOrInsert();
    var id = res[0];
    var status = res[1];

    if (id == null || status == null) {
      return null;
    } else {
      return [id, status];
    }
  }

  Future<void> registerAlarm(int id, int status) async {
    var before = _model.getBeforeEditingData();
    var being = _model.getBeingEditingData();

    KotlinMethodCalling.deleteAlarm(
      id,
      before[NotificationsTable.titleKey] ?? being[NotificationsTable.titleKey],
      before[NotificationsTable.contentKey] ??
          being[NotificationsTable.contentKey],
      before[NotificationsTable.timeKey] ?? being[NotificationsTable.timeKey],
    );
    if (being[NotificationsTable.setAlarmKey] == 0) return;

    KotlinMethodCalling.alarm(
      id,
      being[NotificationsTable.titleKey],
      being[NotificationsTable.contentKey],
      being[NotificationsTable.timeKey],
    );
  }

  bool _titleValidate() {
    return titleController.text != "" ? true : false;
  }

  bool _timeValidate() {
    var diff = _model.getBeingEditingData()[NotificationsTable.timeKey] -
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
        Theme.of(context).errorColor,
      );
      return;
    }

    if (_checkSettingAlarm(
            _model.getBeingEditingData()[NotificationsTable.setAlarmKey]) &&
        _timeValidate() == false) {
      ShowSnackBar(
        context,
        AppLocalizations.of(context)!.dateTimeError,
        Theme.of(context).errorColor,
      );
      return;
    }

    var res = await saveToDb();
    if (res == null) return;

    registerAlarm(res[0], res[1]);

    ShowSnackBar(
      context,
      _model.id == null
          ? AppLocalizations.of(context)!.saved
          : AppLocalizations.of(context)!.edited,
      Theme.of(context).primaryColor,
    );

    if (_model.id == null) {
      titleController.clear();
      contentController.clear();
    } else {
      _model.copyToBeforeEditingData();
    }
  }
}
