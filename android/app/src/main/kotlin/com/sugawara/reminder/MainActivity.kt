package com.sugawara.reminder

import io.flutter.embedding.android.FlutterActivity

import android.content.ContentValues
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull
import com.sugawara.reminder.alarm.AlarmRegister
import com.sugawara.reminder.sqlite.Notifications
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
                        val where: String? = methodCall.argument<String>("where") ?: null
                        val whereArgs: Map<String, String>? = methodCall.argument<Map<String, String>>("whereArgs") ?: null
                        val groupBy: String? = methodCall.argument<String>("groupBy") ?: null
                        val having: String? = methodCall.argument<String>("having") ?: null
                        val orderBy: String? = methodCall.argument<String>("orderBy") ?: null
                        val limit: String? = methodCall.argument<String>("limit") ?: null

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
                        values.put("title", methodCall.argument<String>("title").toString())
                        values.put("content", methodCall.argument<String>("content").toString())
                        values.put("frequency", methodCall.argument<Int>("frequency") ?: 0)
                        values.put("time", methodCall.argument<Int>("time") ?: 0)
                        values.put("set_alarm", methodCall.argument<Int>("setAlarm") ?: 0)
                        values.put("deleted", methodCall.argument<Int>("deleted") ?: 0)

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
                            values.put("title", it.toString())
                        }
                        methodCall.argument<String>("content")?.let{
                            values.put("content", it.toString())
                        }
                        methodCall.argument<Int>("frequency")?.let{
                            values.put("frequency", it)
                        }
                        methodCall.argument<Int>("time")?.let{
                            values.put("time", it)
                        }
                        methodCall.argument<Int>("set_alarm")?.let{
                            values.put("set_alarm", it)
                        }
                        methodCall.argument<Int>("deleted")?.let{
                            values.put("deleted", it)
                        }

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
