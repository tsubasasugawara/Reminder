import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/button/form_control_button.dart';
import 'package:reminder/provider/add_reminder_provider.dart';
import 'package:reminder/provider/datetime_provider.dart';
import 'package:reminder/values/colors.dart';
import 'package:reminder/multilingualization/app_localizations.dart';

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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: _textForm(context),
        ),
      ),
      floatingActionButton: Visibility(
        visible: provider.fabVisible,
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
      ),
      bottomNavigationBar: bottomAppBar(context),
    );
  }

  Widget _textForm(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          provider.fabVisible = true;
        } else {
          provider.fabVisible = false;
        }
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: provider.titleController,
              focusNode: provider.titleFocusNode,
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
                focusNode: provider.contentFocusNode,
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
    );
  }

  Widget bottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: AppColors.backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FormControlButton(
            AppLocalizations.of(context)!.cancelButton,
            Colors.red,
            () {
              provider.init();
              Navigator.pop(context);
            },
          ),
          dateTimeSelecter(context),
          FormControlButton(
            AppLocalizations.of(context)!.saveButton,
            Colors.green,
            () {
              provider.saveBtn(context);
            },
          ),
        ],
      ),
    );
  }

  Widget dateTimeSelecter(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          DateTimeProvider(provider.model.dataBeingEditing['time']),
      child: Consumer<DateTimeProvider>(
        builder: (context, dateTimeProvider, child) {
          return ElevatedButton.icon(
            onPressed: () async {
              FocusScope.of(context).unfocus();

              final res = await dateTimeProvider.selectDate(context);
              provider.model.dataBeingEditing['time'] =
                  dateTimeProvider.getMilliSecondsFromEpoch();

              if (res) {
                await dateTimeProvider.selectTime(context);
                provider.model.dataBeingEditing['time'] =
                    dateTimeProvider.getMilliSecondsFromEpoch();
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColors.backgroundColor),
            ),
            icon: const Icon(
              Icons.calendar_month,
              color: Colors.green,
            ),
            label: Text(
              dateTimeProvider.dateTimeFormat(context),
              style: const TextStyle(color: Colors.green),
            ),
          );
        },
      ),
    );
  }
}
