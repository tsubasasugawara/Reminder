package com.sugawara.reminder

import io.flutter.embedding.android.FlutterActivity

import android.os.Bundle

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import androidx.annotation.NonNull
import java.time.LocalDateTime
import com.sugawara.reminder.alarm.AlarmRegister
import com.sugawara.reminder.sharedpreference.SharedPreference
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
                "saveSetting" -> {
                    val dataType = methodCall.argument<String>("dataType")!!
                    val key = methodCall.argument<String>("key")!!
                    val sp = SharedPreference(context)

                    when(dataType) {
                        "int" -> {
                            val value = methodCall.argument<Int>("value")!!
                            sp.saveInt(key, value)
                        }
                        "String" -> {
                            val value = methodCall.argument<String>("value")!!
                            sp.saveString(key, value)
                        }
                        "bool" -> {
                            val value = methodCall.argument<Boolean>("value")!!
                            sp.saveBoolean(key, value)
                        }
                    }
                    result.success(null);
                }
                "getSetting" -> {
                    val dataType = methodCall.argument<String>("dataType")!!
                    val key = methodCall.argument<String>("key")!!
                    val sp = SharedPreference(context)

                    when(dataType) {
                        "int" -> {
                            val res = sp.getInt(key)
                            result.success(res)
                        }
                        "String" -> {
                            val res = sp.getString(key)
                            result.success(res)
                        }
                        "bool" -> {
                            val res = sp.getBoolean(key)
                            result.success(res)
                        }
                    }
                    result.success(null);
                }
            }
        }
    }

    companion object {
        private val CHANNEL = "com.sugawara.reminder/alarm"
    }
}
