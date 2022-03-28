import 'package:flutter/services.dart';
import 'package:reminder/model/db.dart';

class AddReminderModel {
  String title;
  String content;

  int year = 0;
  int month = 0;
  int day = 0;
  int hour = 0;
  int minute = 0;

  var platform = const MethodChannel('com.sugawara.reminder/alarm');

  AddReminderModel(this.title, this.content, int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    year = dateTime.year;
    month = dateTime.month;
    day = dateTime.day;
    hour = dateTime.hour;
    minute = dateTime.minute;
  }

  Future<int?> insert(int time) async {
    var nt = NotificationsTable();
    var id = await nt.insert(title, content, 0, time);
    return id;
  }
}
