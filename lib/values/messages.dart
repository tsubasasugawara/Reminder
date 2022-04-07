import 'package:flutter/cupertino.dart';

class Messages {
  Messages(
      {required this.appTitle,
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
      required this.delete});

  // AppInfo
  // -----------------------------------------------------------------------------------
  final String appTitle;

  // HomeView
  // -----------------------------------------------------------------------------------
  final String notifiedMsg;

  // AddReminderView
  // -----------------------------------------------------------------------------------

  // hint text in forms
  final String titleHintText;
  final String memoHintText;

  // error messages
  final String titleError;
  final String dateTimeError;

  // save or edit message
  final String saved;
  final String edited;

  // form control button's texts
  final String saveButton;
  final String cancelButton;

  final String delete;

  final String dateTimeFormat;

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
        appTitle: 'リマインダー',
        notifiedMsg: '通知済み',
        titleHintText: 'タイトル(必須)',
        memoHintText: 'メモ',
        titleError: 'タイトルを入力してください',
        dateTimeError: '未来の日時を指定してください',
        saved: '登録しました',
        edited: '編集を保存しました',
        saveButton: '保存する',
        cancelButton: 'キャンセル',
        dateTimeFormat: 'yyyy/MM/dd HH:mm',
        delete: '削除する',
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
        saveButton: 'Save',
        cancelButton: 'Cancel',
        dateTimeFormat: 'MM/dd/yyyy hh:mm aa',
        delete: 'Delete',
      );
}
