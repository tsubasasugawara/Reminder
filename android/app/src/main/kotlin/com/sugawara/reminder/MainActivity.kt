package com.sugawara.reminder

import io.flutter.embedding.android.FlutterActivity

import android.content.ContentValues
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull
import com.sugawara.reminder.alarm.AlarmRegister
import com.sugawara.reminder.sqlite.Notifications
import com.sugawara.reminder.sqlite.DBHelper
import android.util.Log

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            methodCall, result ->
            when(methodCall.method) {
                "alarm" -> {
                    val id = methodCall.argument<Int>(DBHelper.idKey)!!
                    val title = methodCall.argument<String>(DBHelper.titleKey).toString()
                    val content = methodCall.argument<String>(DBHelper.contentKey).toString()
                    val time = methodCall.argument<Long>(DBHelper.timeKey)!!
                    val frequency = methodCall.argument<Int>(DBHelper.frequencyKey) ?: 0
                    val register = AlarmRegister(context)

                    register.registAlarm(id,title,content,time,frequency)
                    result.success(null);
                }
                "deleteAlarm" -> {
                    val id = methodCall.argument<Int>(DBHelper.idKey)!!
                    val title = methodCall.argument<String>(DBHelper.titleKey).toString()
                    val content = methodCall.argument<String>(DBHelper.contentKey).toString()
                    val time = methodCall.argument<Long>(DBHelper.timeKey)!!
                    val frequency = methodCall.argument<Int>(DBHelper.frequencyKey) ?: 0

                    val register = AlarmRegister(context)
                    register.deleteAlarm(id,title,content,time,frequency)
                    result.success(null);
                }
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
                        values.put(DBHelper.titleKey, methodCall.argument<String>(DBHelper.titleKey).toString())
                        values.put(DBHelper.contentKey, methodCall.argument<String>(DBHelper.contentKey).toString())
                        values.put(DBHelper.frequencyKey, methodCall.argument<Int>(DBHelper.frequencyKey) ?: 0)
                        values.put(DBHelper.timeKey, methodCall.argument<Long>(DBHelper.timeKey) ?: 0)
                        values.put(DBHelper.setAlarmKey, methodCall.argument<Int>(DBHelper.setAlarmKey) ?: 0)
                        values.put(DBHelper.deletedKey, methodCall.argument<Int>(DBHelper.deletedKey) ?: 0)
                        values.put(DBHelper.createdAtKey, System.currentTimeMillis())
                        values.put(DBHelper.updatedAtKey, System.currentTimeMillis())

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
                        methodCall.argument<String>(DBHelper.titleKey)?.let{
                            values.put(DBHelper.titleKey, it.toString())
                        }
                        methodCall.argument<String>(DBHelper.contentKey)?.let{
                            values.put(DBHelper.contentKey, it.toString())
                        }
                        methodCall.argument<Int>(DBHelper.frequencyKey)?.let{
                            values.put(DBHelper.frequencyKey, it)
                        }
                        methodCall.argument<Long>(DBHelper.timeKey)?.let{
                            values.put(DBHelper.timeKey, it)
                        }
                        methodCall.argument<Int>(DBHelper.setAlarmKey)?.let{
                            values.put(DBHelper.setAlarmKey, it)
                        }
                        methodCall.argument<Int>(DBHelper.deletedKey)?.let{
                            values.put(DBHelper.deletedKey, it)
                        }
                        values.put(DBHelper.updatedAtKey, System.currentTimeMillis())

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
