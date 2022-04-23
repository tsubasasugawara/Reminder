import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/model/db/db.dart';
import 'package:reminder/provider/add_reminder/add_reminder_provider.dart';
import 'package:reminder/provider/add_reminder/alarm_switch_button.dart';
import 'package:reminder/provider/datetime_provider.dart';
import 'package:reminder/values/colors.dart';
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
  }) : super(key: key) {
    provider = AddReminderProvider(id, title, content, time, setAlarm);
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
    return AppBar(
      actions: [
        ChangeNotifierProvider(
          create: (context) => AlarmSwitchButtonProvider(
            provider.getInt(NotificationsTable.setAlarmKey, false),
          ),
          child: Consumer<AlarmSwitchButtonProvider>(
            builder: (context, alarmSwitchProvider, child) {
              return alarmSwitchProvider.changeIcon(
                context,
                () {
                  provider.setInt(NotificationsTable.setAlarmKey, false,
                      alarmSwitchProvider.setAlarm);
                },
              );
            },
          ),
        ),
      ],
    );
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
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: provider.textsize + 8,
                ),
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.titleHintText,
                  hintStyle: TextStyle(
                    color: Colors.white60,
                    fontSize: provider.textsize + 8,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(10),
                ),
                onChanged: (text) {
                  provider.setString(NotificationsTable.titleKey, false, text);
                },
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: provider.contentController,
                  expands: true,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: provider.textsize,
                  ),
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.memoHintText,
                    hintStyle: TextStyle(
                      color: Colors.white60,
                      fontSize: provider.textsize,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(10),
                  ),
                  onChanged: (text) {
                    provider.setString(
                        NotificationsTable.contentKey, false, text);
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
        child: const Icon(
          Icons.keyboard_hide_outlined,
          size: 40,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FormControlButton(
            AppLocalizations.of(context)!.cancelButton,
            AppColors.error,
            () {
              Navigator.of(context).pop();
            },
          ),
          _dateTimeSelecter(context),
          FormControlButton(
            AppLocalizations.of(context)!.saveButton,
            AppColors.mainColor,
            () {
              provider.saveBtn(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _dateTimeSelecter(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DateTimeProvider(
        provider.getInt(NotificationsTable.timeKey, false),
      ),
      child: Consumer<DateTimeProvider>(
        builder: (context, dateTimeProvider, child) {
          return ElevatedButton.icon(
            onPressed: () async {
              FocusScope.of(context).unfocus();

              await dateTimeProvider.selectDateTime(context);
              provider.setInt(NotificationsTable.timeKey, false,
                  dateTimeProvider.getMilliSecondsFromEpoch());
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.backgroundColor),
            ),
            icon: const Icon(
              Icons.calendar_month,
              color: AppColors.mainColor,
            ),
            label: Text(
              dateTimeProvider.dateTimeFormat(context),
              style: const TextStyle(color: AppColors.mainColor),
            ),
          );
        },
      ),
    );
  }
}
