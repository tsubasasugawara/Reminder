import 'package:flutter/services.dart';

class KotlinMethodCalling {
  static String channelName = "com.sugawara.reminder/alarm";
  static String primaryColorKey = "primaryColor";

  static Future<void> alarm(
    int id,
    String title,
    String content,
    int time,
  ) async {
    await MethodChannel(KotlinMethodCalling.channelName).invokeMethod(
      "alarm",
      <String, dynamic>{
        'id': id,
        'title': title,
        'content': content,
        'time': time
      },
    );
  }

  static Future<void> deleteAlarm(
    int id,
    String title,
    String content,
    int time,
  ) async {
    await MethodChannel(KotlinMethodCalling.channelName).invokeMethod(
      "deleteAlarm",
      <String, dynamic>{
        'id': id,
        'title': title,
        'content': content,
        'time': time,
      },
    );
  }
}
