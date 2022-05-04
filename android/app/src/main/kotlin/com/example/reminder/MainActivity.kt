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
            }
        }
    }

    companion object {
        private val CHANNEL = "com.sugawara.reminder/alarm"
    }
}
