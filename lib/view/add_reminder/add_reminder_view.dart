import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/provider/add_reminder/add_reminder_provider.dart';
import 'package:reminder/provider/add_reminder/alarm_switch_button.dart';
import 'package:reminder/provider/add_reminder/datetime_provider.dart';
import 'package:reminder/values/colors.dart';
import 'package:reminder/multilingualization/app_localizations.dart';
import 'package:reminder/view/add_reminder/button/form_control_button.dart';

// ignore: must_be_immutable
class AddReminderView extends StatelessWidget {
  late AddReminderProvider provider;

  AddReminderView(
      int? id, String? title, String? content, int? time, int? setAlarm,
      {Key? key})
      : super(key: key) {
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
              provider.model.dataBeingEditing["set_alarm"]),
          child: Consumer<AlarmSwitchButtonProvider>(
            builder: (context, alarmSwitchProvider, child) {
              return alarmSwitchProvider.changeIcon(
                context,
                () {
                  provider.model.dataBeingEditing["set_alarm"] =
                      alarmSwitchProvider.setAlarm;
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
                  provider.model.dataBeingEditing["title"] = text;
                  provider.titleValidate();
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
                    provider.model.dataBeingEditing["content"] = text;
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
              provider.init();
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
      create: (context) =>
          DateTimeProvider(provider.model.dataBeingEditing['time']),
      child: Consumer<DateTimeProvider>(
        builder: (context, dateTimeProvider, child) {
          return ElevatedButton.icon(
            onPressed: () async {
              FocusScope.of(context).unfocus();

              await dateTimeProvider.selectDateTime(context);
              provider.model.dataBeingEditing['time'] =
                  dateTimeProvider.getMilliSecondsFromEpoch();
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
