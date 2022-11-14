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
                    val id = methodCall.argument<Int>("id")!!
                    val title = methodCall.argument<String>("title").toString()
                    val content = methodCall.argument<String>("content").toString()
                    val time = methodCall.argument<Long>("time")!!
                    val register = AlarmRegister(context)

                    register.registAlarm(id,title,content,time)
                    result.success(null);
                }
                "deleteAlarm" -> {
                    val id = methodCall.argument<Int>("id")!!
                    val title = methodCall.argument<String>("title").toString()
                    val content = methodCall.argument<String>("content").toString()
                    val time = methodCall.argument<Long>("time")!!

                    val register = AlarmRegister(context)
                    register.deleteAlarm(id,title,content,time)
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
                        values.put(DBHelper.titleKey, methodCall.argument<String>("title").toString())
                        values.put(DBHelper.contentKey, methodCall.argument<String>("content").toString())
                        values.put(DBHelper.frequencyKey, methodCall.argument<Int>("frequency") ?: 0)
                        values.put(DBHelper.timeKey, methodCall.argument<Long>("time") ?: 0)
                        values.put(DBHelper.setAlarmKey, methodCall.argument<Int>("setAlarm") ?: 0)
                        values.put(DBHelper.deletedKey, methodCall.argument<Int>("deleted") ?: 0)
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
                        methodCall.argument<String>("title")?.let{
                            Log.d("update title", it.toString())
                            values.put(DBHelper.titleKey, it.toString())
                        }
                        methodCall.argument<String>("content")?.let{
                            values.put(DBHelper.contentKey, it.toString())
                        }
                        methodCall.argument<Int>("frequency")?.let{
                            values.put(DBHelper.frequencyKey, it)
                        }
                        methodCall.argument<Long>("time")?.let{
                            values.put(DBHelper.timeKey, it)
                        }
                        methodCall.argument<Int>("setAlarm")?.let{
                            values.put(DBHelper.setAlarmKey, it)
                        }
                        methodCall.argument<Int>("deleted")?.let{
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
