import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/provider/add_reminder_provider.dart';
import 'package:reminder/provider/datetime_provider.dart';
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
        foregroundColor: Colors.white,
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
                    hintText: "Title(required)",
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
                    hintText: "Memo(not required)",
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
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.black,
                          ),
                          label: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            provider.init();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.save,
                          color: Colors.black,
                        ),
                        label: const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          provider.saveBtn(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
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
    return Consumer<DateTimeProvider>(
      builder: (context, dateTimeProvider, child) {
        dateTimeProvider.setModel(provider.model.millisecondsFromEpoch);
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
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
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
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
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
    );
  }
}
