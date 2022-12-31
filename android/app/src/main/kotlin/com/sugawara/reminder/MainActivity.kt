package com.sugawara.reminder

import io.flutter.embedding.android.FlutterActivity

import android.content.ContentValues
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull
import com.sugawara.reminder.alarm.AlarmRegister
import com.sugawara.reminder.sqlite.notifications.Notifications
import com.sugawara.reminder.sqlite.notifications.NotificationsHelper
import android.util.Log

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            methodCall, result ->
            when(methodCall.method) {
                "alarm" -> {
                    val id = methodCall.argument<Int>(NotificationsHelper.idKey)!!
                    val title = methodCall.argument<String>(NotificationsHelper.titleKey).toString()
                    val content = methodCall.argument<String>(NotificationsHelper.contentKey).toString()
                    val time = methodCall.argument<Long>(NotificationsHelper.timeKey)!!
                    val frequency = methodCall.argument<Int>(NotificationsHelper.frequencyKey) ?: 0
                    val register = AlarmRegister(context)

                    register.registAlarm(id,title,content,time,frequency)
                    result.success(null);
                }
                "deleteAlarm" -> {
                    val id = methodCall.argument<Int>(NotificationsHelper.idKey)!!
                    val title = methodCall.argument<String>(NotificationsHelper.titleKey).toString()
                    val content = methodCall.argument<String>(NotificationsHelper.contentKey).toString()
                    val time = methodCall.argument<Long>(NotificationsHelper.timeKey)!!
                    val frequency = methodCall.argument<Int>(NotificationsHelper.frequencyKey) ?: 0

                    val register = AlarmRegister(context)
                    register.deleteAlarm(id,title,content,time,frequency)
                    result.success(null);
                }
                // TODO: selectでなく、notifications_selectのようにする
                "select" -> {
                    try {
                        val columns = methodCall.argument<Map<String, String>>("columns")!!
                        val where: String? = methodCall.argument<String>("where")
                        val whereArgs: Map<String, String>? = methodCall.argument<Map<String, String>>("whereArgs")
                        val groupBy: String? = methodCall.argument<String>("groupBy")
                        val having: String? = methodCall.argument<String>("having")
                        val orderBy: String? = methodCall.argument<String>("orderBy")
                        val limit: String? = methodCall.argument<String>("limit")

                        var notifications = Notifications()
                        val res = notifications.select(
                            context = context,
                            columns = notifications.mapToArray(columns)!!,
                            where = where,
                            whereArgs = notifications.mapToArray(whereArgs),
                            groupBy = groupBy,
                            having = having,
                            orderBy = orderBy,
                            limit = limit,
                        )
                        result.success(res)
                    } catch(e: Exception) {
                        Log.d("select", e.toString())
                        result.success(null)
                    }
                }
                "insert" -> {
                    try {
                        val values = ContentValues()
                        values.put(NotificationsHelper.titleKey, methodCall.argument<String>(NotificationsHelper.titleKey).toString())
                        values.put(NotificationsHelper.contentKey, methodCall.argument<String>(NotificationsHelper.contentKey).toString())
                        values.put(NotificationsHelper.frequencyKey, methodCall.argument<Int>(NotificationsHelper.frequencyKey) ?: 0)
                        values.put(NotificationsHelper.timeKey, methodCall.argument<Long>(NotificationsHelper.timeKey) ?: 0)
                        values.put(NotificationsHelper.setAlarmKey, methodCall.argument<Int>(NotificationsHelper.setAlarmKey) ?: 0)
                        values.put(NotificationsHelper.deletedKey, methodCall.argument<Int>(NotificationsHelper.deletedKey) ?: 0)
                        values.put(NotificationsHelper.createdAtKey, System.currentTimeMillis())
                        values.put(NotificationsHelper.updatedAtKey, System.currentTimeMillis())

                        var notifications = Notifications()
                        var res = notifications.insert(
                            context = context,
                            values = values,
                        )
                        result.success(res)
                    } catch(e: Exception) {
                        Log.d("insert", e.toString())
                        result.success(null)
                    }
                }
                "update" -> {
                    try {
                        val where: String? = methodCall.argument<String>("where") ?: null
                        val whereArgs: Map<String, String>? = methodCall.argument<Map<String, String>>("whereArgs") ?: null

                        val values = ContentValues()
                        methodCall.argument<String>(NotificationsHelper.titleKey)?.let{
                            values.put(NotificationsHelper.titleKey, it.toString())
                        }
                        methodCall.argument<String>(NotificationsHelper.contentKey)?.let{
                            values.put(NotificationsHelper.contentKey, it.toString())
                        }
                        methodCall.argument<Int>(NotificationsHelper.frequencyKey)?.let{
                            values.put(NotificationsHelper.frequencyKey, it)
                        }
                        methodCall.argument<Long>(NotificationsHelper.timeKey)?.let{
                            values.put(NotificationsHelper.timeKey, it)
                        }
                        methodCall.argument<Int>(NotificationsHelper.setAlarmKey)?.let{
                            values.put(NotificationsHelper.setAlarmKey, it)
                        }
                        methodCall.argument<Int>(NotificationsHelper.deletedKey)?.let{
                            values.put(NotificationsHelper.deletedKey, it)
                        }
                        values.put(NotificationsHelper.updatedAtKey, System.currentTimeMillis())

                        var notifications = Notifications()
                        var res = notifications.update(
                            context = context,
                            values = values,
                            whereClause = where,
                            whereArgs = notifications.mapToArray(whereArgs),
                        )

                        result.success(res)
                    } catch(e: Exception) {
                        Log.d("update", e.toString())
                        result.success(null)
                    }
                }
                "delete" -> {
                    try {
                        val where: String? = methodCall.argument<String>("where") ?: null
                        val whereArgs: Map<String, String>? = methodCall.argument<Map<String, String>>("whereArgs") ?: null

                        var notifications = Notifications()
                        var res = notifications.delete(
                            context = context,
                            whereClause = where,
                            whereArgs = notifications.mapToArray(whereArgs),
                        )

                        result.success(res)
                    } catch(e: Exception) {
                        Log.d("delete", e.toString())
                        result.success(null)
                    }
                }
            }
        }
    }

    companion object {
        private val CHANNEL = "com.sugawara.reminder/alarm"
    }
}
