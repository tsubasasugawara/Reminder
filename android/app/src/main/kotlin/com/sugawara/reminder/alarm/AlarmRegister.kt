package com.sugawara.reminder.alarm

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import com.sugawara.reminder.alarm.AlarmReceiver

class AlarmRegister(_context: Context) {

    private val context = _context

    @SuppressLint("UnspecifiedImmutableFlag")
    fun registAlarm(
        id: Int,
        title: String,
        content: String,
        millis: Long,
        // created: Boolean
    ){
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = createIntent(id, title, content, millis)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT
        )

        val alarmInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            AlarmManager.AlarmClockInfo(
                millis,
                null
            )
        } else {
            TODO("VERSION.SDK_INT < LOLLIPOP")
        }

        alarmManager.setAlarmClock(
            alarmInfo,
            pendingIntent
        )
    }

    @SuppressLint("UnspecifiedImmutableFlag")
    fun deleteAlarm(
        id: Int,
        title: String,
        content: String,
        millis: Long
    ){
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = createIntent(id, title, content, millis)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT
        )

        alarmManager.cancel(pendingIntent)

    }


    private fun createIntent(
        id: Int,
        title: String,
        content: String,
        millis: Long
    ): Intent {
        return Intent(this.context, AlarmReceiver::class.java)
            .also {
                it.putExtra("id", id)
                it.putExtra("title",title)
                it.putExtra("content",content)
                it.putExtra("time", millis)
            }
    }
}
