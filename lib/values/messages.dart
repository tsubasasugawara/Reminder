import 'package:flutter/cupertino.dart';

class Messages {
  Messages({
    required this.appTitle,
    required this.notifiedMsg,
    required this.titleHintText,
    required this.memoHintText,
    required this.titleError,
    required this.dateTimeError,
    required this.saved,
    required this.edited,
    required this.saveButton,
    required this.cancelButton,
    required this.dateTimeFormat,
    required this.setAlarmOff,
    required this.setAlarmOn,
    required this.deletedReminder,
    required this.timeFormat,
    required this.ok,
    required this.home,
    required this.setting,
    required this.colorSetting,
    required this.uiModeSetting,
    required this.refresh,
    required this.confirmation,
    required this.deletionConfirmationMsg,
    required this.trash,
    required this.movingToTrashConfirmationMsg,
    required this.moveReminderToTrash,
    required this.restoreReminderToTrash,
  });

  final String appTitle;
  final String notifiedMsg;
  final String titleHintText;
  final String memoHintText;
  final String titleError;
  final String dateTimeError;
  final String saved;
  final String edited;
  final String saveButton;
  final String cancelButton;
  final String dateTimeFormat;
  final String deletedReminder;
  final String setAlarmOff;
  final String setAlarmOn;
  final String timeFormat;
  final String ok;
  final String home;
  final String setting;
  final String colorSetting;
  final String uiModeSetting;
  final String refresh;
  final String confirmation;
  final String deletionConfirmationMsg;
  final String trash;
  final String movingToTrashConfirmationMsg;
  final String moveReminderToTrash;
  final String restoreReminderToTrash;

  factory Messages.of(Locale locale) {
    switch (locale.languageCode) {
      case 'ja':
        return Messages.ja();
      case 'en':
        return Messages.en();
      default:
        return Messages.en();
    }
  }

  factory Messages.ja() => Messages(
        appTitle: '??????????????????',
        notifiedMsg: '????????????',
        titleHintText: '????????????(??????)',
        memoHintText: '??????',
        titleError: '???????????????????????????????????????',
        dateTimeError: '??????????????????????????????????????????',
        saved: '??????????????????',
        edited: '???????????????????????????',
        saveButton: '????????????',
        cancelButton: '???????????????',
        dateTimeFormat: 'yyyy/MM/dd HH:mm',
        setAlarmOff: '??????',
        setAlarmOn: '??????',
        deletedReminder: '??????????????????',
        moveReminderToTrash: "??????????????????????????????",
        restoreReminderToTrash: "??????????????????",
        timeFormat: 'HH:mm',
        ok: "??????",
        home: "?????????",
        setting: "??????",
        colorSetting: "?????????",
        uiModeSetting: "?????????",
        refresh: "??????",
        confirmation: "??????",
        deletionConfirmationMsg: "??????????????????????????????????????????????",
        movingToTrashConfirmationMsg: "???????????????????????????????",
        trash: "?????????",
      );

  factory Messages.en() => Messages(
        appTitle: 'Reminder',
        notifiedMsg: 'Notified',
        titleHintText: 'Title(Required)',
        memoHintText: 'Memo',
        titleError: 'Please enter a title.',
        dateTimeError: 'Please specify a future date and time.',
        saved: 'Registered.',
        edited: 'Edited.',
        saveButton: 'SAVE',
        cancelButton: 'CANCEL',
        dateTimeFormat: 'MM/dd/yyyy hh:mm aa',
        setAlarmOff: 'OFF',
        setAlarmOn: 'ON',
        deletedReminder: 'Deleted.',
        moveReminderToTrash: "Moved to trash.",
        restoreReminderToTrash: "Restored.",
        timeFormat: 'hh:mm aa',
        ok: "OK",
        home: "HOME",
        setting: "Settings",
        colorSetting: "COLOR",
        uiModeSetting: "THEME",
        refresh: "Refresh",
        confirmation: "Confirmation",
        deletionConfirmationMsg: "Are you sure you want to delete?",
        movingToTrashConfirmationMsg:
            "Do you want to move the item to the trash?",
        trash: "Trash",
      );
}
