import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder/provider/add_reminder_provider.dart';
import 'package:reminder/view/home_view.dart';

class AddReminderView extends StatelessWidget {
  final String title;
  final String content;

  // ignore: use_key_in_widget_constructors
  const AddReminderView(this.title, this.content);

  final textsize = 20.0;

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
          child: form(context),
        ),
      ),
    );
  }

  Widget form(context) {
    return Consumer<AddReminderProvider>(
      builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextFormField(
                controller: provider.titleController,
                style: TextStyle(
                  color: HomeView.textColor,
                  fontSize: textsize + 8,
                ),
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: "Title(required)",
                  hintStyle: TextStyle(
                    color: Colors.white60,
                    fontSize: textsize + 8,
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
                  errorText:
                      provider.titleIsOk ? null : "please enter some text.",
                ),
                onChanged: (text) {
                  provider.model.title = text;
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
                  fontSize: textsize,
                ),
                maxLines: 15,
                decoration: InputDecoration(
                  hintText: "Memo(not required)",
                  hintStyle: TextStyle(
                    color: Colors.white60,
                    fontSize: textsize,
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
                  provider.model.content = text;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40, bottom: 40),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        provider.selectDate(context);
                      },
                      child: Text(
                        provider.dateFormat(),
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
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        provider.selectTime(context);
                      },
                      child: Text(
                        provider.timeFormat(),
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
            ),
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
        );
      },
    );
  }
}
