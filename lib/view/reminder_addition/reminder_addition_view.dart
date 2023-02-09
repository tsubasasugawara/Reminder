import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/provider/reminder_addition/datetime/repeating_setting/repeating_setting_provider.dart';
import 'package:reminder/utils/brightness/brightness.dart';
import 'package:reminder/model/db/notifications.dart';
import 'package:reminder/provider/reminder_addition/reminder_addition_provider.dart';
import 'package:reminder/provider/reminder_addition/alarm_switch.dart';
import 'package:reminder/provider/reminder_addition/datetime/datetime_provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:riverpod_context/riverpod_context.dart';

// ignore: must_be_immutable
class ReminderAdditionalView extends StatelessWidget {
  late ReminderAdditionalProvider provider;

  ReminderAdditionalView({
    Key? key,
    int? id,
    String? title,
    String? content,
    int? time,
    int? setAlarm,
    int? frequency,
    bool isTrash = false, // ごみ箱のアイテム(true)、それ以外(false)
  }) : super(key: key) {
    provider = ReminderAdditionalProvider(
      id,
      title,
      content,
      time,
      setAlarm,
      frequency,
      isTrash,
    );
  }

  static Future<void> moveTo(
    BuildContext context, {
    int? id,
    String? title,
    String? content,
    int? time,
    int? setAlarm,
    int? frequency,
    required bool isTrash,
  }) async {
    var dt = time != null
        ? DateTime.fromMillisecondsSinceEpoch(time)
        : DateTime.now();

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return ProviderScope(
          overrides: [
            alarmSwhitchProvider.overrideWith((ref) =>
                AlarmSwitchProvider(setAlarm ?? Notifications.alarmOff)),
            dateTimeProvider.overrideWith((ref) => DateTimeProvider(dt)),
            repeatingSettingProvider
                .overrideWith((ref) => RepeatingSettingProvider(frequency)),
          ],
          child: ReminderAdditionalView(
            id: id,
            title: title,
            content: content,
            time: time,
            setAlarm: setAlarm,
            frequency: frequency,
            isTrash: isTrash,
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar();
  }

  Widget _textForm(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Container(
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: provider.titleController,
                style: Theme.of(context).textTheme.bodyText1?.apply(
                      fontSizeDelta: 6,
                    ),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.titleHintText,
                  hintStyle: Theme.of(context).textTheme.bodyText1?.apply(
                        fontSizeDelta: 6,
                        color: Theme.of(context).hintColor,
                      ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: provider.contentController,
                  expands: true,
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.memoHintText,
                    hintStyle: Theme.of(context).textTheme.bodyText1?.apply(
                          color: Theme.of(context).hintColor,
                        ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fab(BuildContext context) {
    return Visibility(
      visible: provider.isKeyboardShown,
      child: FloatingActionButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Icon(
          Icons.keyboard_hide_outlined,
          size: 40,
          color: judgeBlackWhite(Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  /*
   * アイコンボタンを作成
   * @param context:BuildContext
   * @param foregroundColor:アイコンの色
   * @param action:アイコンを押したときの処理
   * @param icon:アイコン
   * @param label:アイコンの説明文
   * @return Widget:アイコンボタン
   */
  Widget _textButtonIcon(
    BuildContext context,
    Color foregroundColor,
    Function() action,
    IconData icon,
    String label,
  ) {
    return TextButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Theme.of(context).bottomAppBarColor,
        ),
        foregroundColor: MaterialStateProperty.all(
          foregroundColor,
        ),
      ),
      onPressed: () {
        action();
      },
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Widget _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: Consumer(
              builder: (context, ref, child) {
                int setAlarm = ref.watch(alarmSwhitchProvider).setAlarm;

                return provider.isTrash
                    ? _textButtonIcon(
                        context,
                        Theme.of(context).hintColor,
                        () => null,
                        Icons.alarm_off,
                        AppLocalizations.of(context)!.setAlarmOff,
                      )
                    : _textButtonIcon(
                        context,
                        setAlarm == Notifications.alarmOff
                            ? Theme.of(context).hintColor
                            : Theme.of(context).primaryColor,
                        () {
                          context
                              .read(alarmSwhitchProvider.notifier)
                              .changeAlarmOnOff(1 - setAlarm);
                        },
                        setAlarm == Notifications.alarmOff
                            ? Icons.alarm_off
                            : Icons.alarm_on,
                        setAlarm == Notifications.alarmOff
                            ? AppLocalizations.of(context)!.setAlarmOff
                            : AppLocalizations.of(context)!.setAlarmOn,
                      );
              },
            ),
          ),
          Expanded(
            flex: 5,
            child: _dateTimeSelector(context),
          ),
          Expanded(
            flex: 3,
            child: TextButton(
              onPressed: () {
                provider.saveBtn(context);
              },
              child: Text(
                AppLocalizations.of(context)!.saveButton,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTimeSelector(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        var dt = ref.watch(dateTimeProvider).dt;

        return TextButton.icon(
          onPressed: () async {
            FocusScope.of(context).unfocus();

            await ref.read(dateTimeProvider.notifier).selectDateTime(
                  context,
                  dateTime: dt,
                );
          },
          icon: Icon(
            Icons.calendar_month,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            ref.read(dateTimeProvider.notifier).dateTimeFormat(context),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    provider.isKeyboardShown = 0 < MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: _appBar(context),
      body: _textForm(context),
      floatingActionButton: _fab(context),
      bottomNavigationBar: _bottomAppBar(context),
    );
  }
}
