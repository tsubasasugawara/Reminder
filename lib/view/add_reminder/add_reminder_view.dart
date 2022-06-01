import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/brightness/brightness.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/provider/add_reminder/add_reminder_provider.dart';
import 'package:reminder/provider/add_reminder/alarm_switch_button.dart';
import 'package:reminder/provider/add_reminder/datetime/datetime_provider.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/view/add_reminder/button/form_control_button.dart';

// ignore: must_be_immutable
class AddReminderView extends StatelessWidget {
  late AddReminderProvider provider;

  AddReminderView({
    Key? key,
    int? id,
    String? title,
    String? content,
    int? time,
    int? setAlarm,
    bool isTrash = false, // ごみ箱のアイテム(true)、それ以外(false)
  }) : super(key: key) {
    provider = AddReminderProvider(id, title, content, time, setAlarm, isTrash);
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
                onChanged: (text) {
                  provider.setData(title: text);
                },
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
                  onChanged: (text) {
                    provider.setData(content: text);
                  },
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

  Widget _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: ChangeNotifierProvider(
              create: (context) => AlarmSwitchButtonProvider(
                provider.getData(NotificationsTable.setAlarmKey),
              ),
              child: Consumer<AlarmSwitchButtonProvider>(
                builder: (context, alarmSwitchProvider, child) {
                  return alarmSwitchProvider.changeIcon(
                    context,
                    () {
                      provider.setData(setAlarm: alarmSwitchProvider.setAlarm);
                    },
                    isTrash: provider.isTrash,
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: _dateTimeSelecter(context),
          ),
          Expanded(
            flex: 3,
            child: FormControlButton(
              AppLocalizations.of(context)!.saveButton,
              Theme.of(context).primaryColor,
              () {
                provider.saveBtn(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateTimeSelecter(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DateTimeProvider(
        provider.getData(NotificationsTable.timeKey),
      ),
      child: Consumer<DateTimeProvider>(
        builder: (context, dateTimeProvider, child) {
          return TextButton.icon(
            onPressed: () async {
              FocusScope.of(context).unfocus();

              await dateTimeProvider.selectDateTime(context);
              provider.setData(
                time: dateTimeProvider.getMilliSecondsFromEpoch(),
              );
            },
            icon: Icon(
              Icons.calendar_month,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              dateTimeProvider.dateTimeFormat(context),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          );
        },
      ),
    );
  }
}
