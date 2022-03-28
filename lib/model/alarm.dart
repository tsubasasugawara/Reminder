import 'package:flutter/services.dart';

class Alarm {
  static var platform = const MethodChannel('com.sugawara.reminder/alarm');

  static Future<void> alarm(
      int id, String title, String content, int time, bool created) async {
    await platform.invokeMethod(
      "alarm",
      <String, dynamic>{
        'id': id,
        'title': title,
        'content': content,
        'time': time,
        'created': created,
      },
    );
  }

  static Future<void> deleteAlarm(int id, String title, String content) async {
    await platform.invokeMethod(
      "deleteAlarm",
      <String, dynamic>{
        'id': id,
        'title': title,
        'content': content,
      },
    );
  }
}
