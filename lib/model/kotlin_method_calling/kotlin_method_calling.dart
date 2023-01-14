import 'package:flutter/services.dart';

import '../db/notifications.dart';

class KotlinMethodCalling {
  static const String channelName = "com.sugawara.reminder/alarm";
  static const String primaryColorKey = "primaryColor";

  // ignore:todo
  // TODO:dart側ではidのみ送信し、その他はkotlin側で取得する

  /*
   * アラームをスケジューリング
   * @param id:ID
   * @param title:タイトル
   * @param content:メモ
   * @param time:発火時間
   * @param frequency:繰り返し間隔
   */
  static Future<void> registAlarm(
    int id,
    String title,
    String content,
    int time,
    int frequency,
  ) async {
    await const MethodChannel(KotlinMethodCalling.channelName).invokeMethod(
      "alarm",
      <String, dynamic>{
        Notifications.idKey: id,
        Notifications.titleKey: title,
        Notifications.contentKey: content,
        Notifications.timeKey: time,
        Notifications.frequencyKey: frequency,
      },
    );
  }

  /*
   * アラームを解除する
   * @param id:ID
   * @param title:タイトル
   * @param content:メモ
   * @param time:発火時間
   * @param frequency:繰り返し間隔
   */
  static Future<void> deleteAlarm(
    int id,
    String title,
    String content,
    int time,
    int frequency,
  ) async {
    await const MethodChannel(KotlinMethodCalling.channelName).invokeMethod(
      "deleteAlarm",
      <String, dynamic>{
        Notifications.idKey: id,
        Notifications.titleKey: title,
        Notifications.contentKey: content,
        Notifications.timeKey: time,
        Notifications.frequencyKey: frequency,
      },
    );
  }
}
