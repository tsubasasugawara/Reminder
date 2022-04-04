import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/button/datetime_picker_button.dart';
import 'package:reminder/components/button/form_control_button.dart';
import 'package:reminder/components/text_form_field/add_reminder_text_form.dart';
import 'package:reminder/provider/add_reminder_provider.dart';
import 'package:reminder/provider/datetime_provider.dart';
import 'package:reminder/values/colors.dart';
import 'package:reminder/values/strings.dart';

// ignore: must_be_immutable
class AddReminderView extends StatelessWidget {
  late AddReminderProvider provider;

  AddReminderView(int? id, String? title, String? content, int? time,
      {Key? key})
      : super(key: key) {
    provider = AddReminderProvider(id, title, content, time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            children: <Widget>[
              _textForm(context),
              // _dateTimePickers(context),
              // _formControlButtons(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomAppBar(context),
    );
  }

  Widget _textForm(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: AddReminderTextForm(
            provider.titleController,
            provider.textsize + 8,
            (text) {
              provider.model.dataBeingEditing["title"] = text;
              provider.titleValidate();
            },
            null,
            2,
            AppStrings.titleHintText,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: AddReminderTextForm(
            provider.contentController,
            provider.textsize,
            (text) {
              provider.model.dataBeingEditing["content"] = text;
            },
            null,
            15,
            AppStrings.memoHintText,
          ),
        ),
      ],
    );
  }

  Widget _dateTimePickers(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          DateTimeProvider(provider.model.dataBeingEditing['time']),
      child: Consumer<DateTimeProvider>(
        builder: (context, dateTimeProvider, child) {
          return Container(
            margin: const EdgeInsets.only(top: 40, bottom: 40),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DateTimePickerButton(
                    dateTimeProvider.dateFormat(),
                    () async {
                      FocusScope.of(context).unfocus();
                      await dateTimeProvider.selectDate(context);
                      provider.model.dataBeingEditing['time'] =
                          dateTimeProvider.getMilliSecondsFromEpoch();
                    },
                  ),
                  DateTimePickerButton(
                    dateTimeProvider.timeFormat(),
                    () async {
                      FocusScope.of(context).unfocus();
                      await dateTimeProvider.selectTime(context);
                      provider.model.dataBeingEditing['time'] =
                          dateTimeProvider.getMilliSecondsFromEpoch();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _formControlButtons(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 30),
            child: Center(
              child: FormControlButton(
                Icons.cancel,
                Colors.red,
                AppStrings.cancelButton,
                () {
                  provider.init();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Center(
            child: FormControlButton(
              Icons.save,
              Colors.green,
              AppStrings.saveButton,
              () {
                provider.saveBtn(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: AppColors.backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              provider.init();
              Navigator.pop(context);
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.backgroundColor),
            ),
            child: Text(
              AppStrings.cancelButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          // 画面に重ねて表示する(その中にdatepickerとtimepickerを入れる)
          ElevatedButton.icon(
            onPressed: () async {},
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.backgroundColor),
            ),
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.green,
            ),
            label: Text(
              "2022/3/4 23:40",
              style: TextStyle(color: Colors.green),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              provider.saveBtn(context);
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.backgroundColor),
            ),
            child: Text(
              AppStrings.saveButton,
              style: const TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
