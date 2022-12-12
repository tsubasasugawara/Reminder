import 'package:flutter/services.dart';

import '../db/db.dart';

class KotlinMethodCalling {
  static String channelName = "com.sugawara.reminder/alarm";
  static String primaryColorKey = "primaryColor";

  // TODO: dart側ではidのみ送信し、その他はkotlin側で取得する

  /*
   * アラームをスケジューリング
   * @param id : ID
   * @param title : タイトル
   * @param content : メモ
   * @param time : 発火時間
   */
  static Future<void> registAlarm(
    int id,
    String title,
    String content,
    int time,
  ) async {
    await MethodChannel(KotlinMethodCalling.channelName).invokeMethod(
      "alarm",
      <String, dynamic>{
        Notifications.idKey: id,
        Notifications.titleKey: title,
        Notifications.contentKey: content,
        Notifications.timeKey: time
      },
    );
  }

  /*
   * アラームを解除する
   * @param id : ID
   * @param title : タイトル
   * @param content : メモ
   * @param time : 発火時間
   */
  static Future<void> deleteAlarm(
    int id,
    String title,
    String content,
    int time,
  ) async {
    await MethodChannel(KotlinMethodCalling.channelName).invokeMethod(
      "deleteAlarm",
      <String, dynamic>{
        Notifications.idKey: id,
        Notifications.titleKey: title,
        Notifications.contentKey: content,
        Notifications.timeKey: time,
      },
    );
  }
}
