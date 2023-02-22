import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder/provider/reminder_addition/datetime/repeating_setting/repeating_setting_provider.dart';
import 'package:reminder/provider/setting/theme/theme_provider.dart';
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
    String? title,
    String? content,
    int? id,
    required bool isTrash, // ごみ箱のアイテム(true)、それ以外(false)
  }) : super(key: key) {
    provider = ReminderAdditionalProvider(
      id,
      title,
      content,
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

    context
        .read(alarmSwhitchProvider.notifier)
        .changeAlarmOnOff(setAlarm ?? Notifications.alarmOn);
    context.read(dateTimeProvider.notifier).changeDateTime(
          currentDateTime: dt,
          editingDateTime: dt,
        );
    context.read(repeatingSettingProvider.notifier).setDays(frequency);

    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return ReminderAdditionalView(
          id: id,
          title: title,
          content: content,
          isTrash: isTrash,
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
                style: Theme.of(context).textTheme.bodyLarge?.apply(
                      fontSizeDelta: 6,
                    ),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.titleHintText,
                  hintStyle: Theme.of(context).textTheme.bodyLarge?.apply(
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
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.memoHintText,
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.apply(
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
                          ref
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
            child: _dateTimeSelector(),
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

  Widget _dateTimeSelector() {
    return Consumer(
      builder: (context, ref, child) {
        var dt = ref.watch(dateTimeProvider).currentDateTime;

        return TextButton.icon(
          onPressed: () async {
            FocusScope.of(context).unfocus();

            await ref.read(dateTimeProvider.notifier).selectDateTime(
                  context,
                  ref.read(themeProvider).uiMode,
                  dateTime: dt,
                );
          },
          icon: Icon(
            Icons.calendar_month,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            ref
                .read(dateTimeProvider.notifier)
                .dateTimeFormat(AppLocalizations.of(context)!.dateTimeFormat),
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
