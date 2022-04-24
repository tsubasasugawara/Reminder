import 'package:flutter/services.dart';

class KotlinMethodCalling {
  static String channelName = "com.sugawara.reminder/alarm";

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

  static Future<void> saveSetting(
    String key,
    dynamic value,
  ) async {
    await MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("saveSetting", <String, dynamic>{
      'key': key,
      'dataType': value.runtimeType,
      'value': value,
    });
  }

  static Future<dynamic> getSetting(
    String key,
    String dataType,
  ) async {
    var res = await MethodChannel(KotlinMethodCalling.channelName)
        .invokeMethod("getSetting", <String, dynamic>{
      'key': key,
      'dataType': dataType,
    });

    return res;
  }
}
