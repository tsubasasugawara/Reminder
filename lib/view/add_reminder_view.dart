import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/components/button/form_control_button.dart';
import 'package:reminder/provider/add_reminder_provider.dart';
import 'package:reminder/provider/datetime_provider.dart';
import 'package:reminder/values/strings.dart';
import 'package:reminder/view/home_view.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  controller: provider.titleController,
                  style: TextStyle(
                    color: HomeView.textColor,
                    fontSize: provider.textsize + 8,
                  ),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: AppStrings.titleHintText,
                    hintStyle: TextStyle(
                      color: Colors.white60,
                      fontSize: provider.textsize + 8,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                  onChanged: (text) {
                    provider.model.dataBeingEditing["title"] = text;
                    provider.titleValidate();
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextFormField(
                  controller: provider.contentController,
                  style: TextStyle(
                    color: HomeView.textColor,
                    fontSize: provider.textsize,
                  ),
                  maxLines: 15,
                  decoration: InputDecoration(
                    hintText: AppStrings.memoHintText,
                    hintStyle: TextStyle(
                      color: Colors.white60,
                      fontSize: provider.textsize,
                    ),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                  onChanged: (text) {
                    provider.model.dataBeingEditing["content"] = text;
                  },
                ),
              ),
              form(context),
              Center(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget form(context) {
    return ChangeNotifierProvider(
      create: (context) =>
          DateTimeProvider(provider.model.millisecondsFromEpoch),
      child: Consumer<DateTimeProvider>(
        builder: (context, dateTimeProvider, child) {
          return Container(
            margin: const EdgeInsets.only(top: 40, bottom: 40),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await dateTimeProvider.selectDate(context);
                      provider.model.millisecondsFromEpoch =
                          dateTimeProvider.getMilliSecondsFromEpoch();
                    },
                    child: Text(
                      dateTimeProvider.dateFormat(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 22),
                      ),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green, width: 1),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await dateTimeProvider.selectTime(context);
                      provider.model.millisecondsFromEpoch =
                          dateTimeProvider.getMilliSecondsFromEpoch();
                    },
                    child: Text(
                      dateTimeProvider.timeFormat(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 22),
                      ),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.green, width: 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
