// import 'package:flutter/services.dart';

// class Alarm {
//   static Future<void> alarm(
//       int id, String title, String content, int time) async {
//     await const MethodChannel('com.sugawara.reminder/alarm').invokeMethod(
//       "alarm",
//       <String, dynamic>{
//         'id': id,
//         'title': title,
//         'content': content,
//         'time': time
//       },
//     );
//   }

//   static Future<void> deleteAlarm(
//       int id, String title, String content, int time) async {
//     await const MethodChannel('com.sugawara.reminder/alarm').invokeMethod(
//       "deleteAlarm",
//       <String, dynamic>{
//         'id': id,
//         'title': title,
//         'content': content,
//         'time': time,
//       },
//     );
//   }
// }
