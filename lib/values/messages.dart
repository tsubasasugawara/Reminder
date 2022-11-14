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
    required this.order,
    required this.orderMethod,
    required this.orderByTitle,
    required this.orderByCreatedAt,
    required this.orderByUpdatedAt,
    required this.orderByAlarmTime,
    required this.orderById,
    required this.sortBy,
    required this.topUpSetAlarmReminder,
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
  final String order;
  final String orderMethod;
  final String orderByTitle;
  final String orderByCreatedAt;
  final String orderByUpdatedAt;
  final String orderByAlarmTime;
  final String orderById;
  final String sortBy;
  final String topUpSetAlarmReminder;

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
      setAlarmOff: 'オフ',
      setAlarmOn: 'オン',
      deletedReminder: '削除しました',
      moveReminderToTrash: 'ごみ箱に移動しました',
      restoreReminderToTrash: '復元しました',
      timeFormat: 'HH:mm',
      ok: '完了',
      home: 'ホーム',
      setting: '設定',
      colorSetting: 'カラー',
      uiModeSetting: 'テーマ',
      refresh: '更新',
      confirmation: '確認',
      deletionConfirmationMsg: '本当に削除してもよろしいですか?',
      movingToTrashConfirmationMsg: 'ごみ箱へ移動しますか?',
      trash: 'ごみ箱',
      order: 'ソート',
      orderMethod: 'ソート方法',
      orderById: "ID",
      orderByTitle: 'タイトル',
      orderByCreatedAt: '作成日',
      orderByUpdatedAt: '更新日',
      orderByAlarmTime: 'アラーム時間',
      sortBy: '[逆順]',
      topUpSetAlarmReminder: '[アラームONを上に表示]');

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
        moveReminderToTrash: 'Moved to trash.',
        restoreReminderToTrash: 'Restored.',
        timeFormat: 'hh:mm aa',
        ok: 'OK',
        home: 'HOME',
        setting: 'Settings',
        colorSetting: 'COLOR',
        uiModeSetting: 'THEME',
        refresh: 'Refresh',
        confirmation: 'Confirmation',
        deletionConfirmationMsg: 'Are you sure you want to delete?',
        movingToTrashConfirmationMsg:
            'Do you want to move the item to the trash?',
        trash: 'Trash',
        order: 'Order',
        orderMethod: 'Order Method',
        orderById: 'ID',
        orderByTitle: 'Title',
        orderByCreatedAt: 'Created date',
        orderByUpdatedAt: 'Updated date',
        orderByAlarmTime: 'Alarm time',
        sortBy: '[Reverse order]',
        topUpSetAlarmReminder: '[Show alarms set on top]',
      );
}
