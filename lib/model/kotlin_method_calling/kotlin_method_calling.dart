import 'package:flutter/services.dart';

class KotlinMethodCalling {
  static String channelName = "com.sugawara.reminder/alarm";
  static String primaryColorKey = "primaryColor";

  /// アラームをスケジューリング
  /// * `id` : ID
  /// * `title` : タイトル
  /// * `content` : メモ
  /// * `time` : 発火時間
  static Future<void> registAlarm(
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

  /// アラームを解除する
  /// * `id` : ID
  /// * `title` : タイトル
  /// * `content` : メモ
  /// * `time` : 発火時間
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
