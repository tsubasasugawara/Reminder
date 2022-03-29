package com.sugawara.reminder.alarm

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import com.sugawara.reminder.alarm.AlarmReceiver

class AlarmRegister(_context: Context) {

    private val context = _context

    @SuppressLint("UnspecifiedImmutableFlag")
    fun registAlarm(
        id: Int,
        title: String,
        content: String,
        millis: Long,
        created: Boolean
    ){
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = createIntent(id,title,content)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT
        )

        if(created) {
            alarmManager.cancel(pendingIntent)
        }

        val alarmInfo = AlarmManager.AlarmClockInfo(
            millis,
            null
        )

        alarmManager.setAlarmClock(
            alarmInfo,
            pendingIntent
        )
    }

    @SuppressLint("UnspecifiedImmutableFlag")
    fun deleteAlarm(
        id: Int,
        title: String,
        content: String
    ){
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = createIntent(id,title,content)
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
        content: String
    ): Intent {
        return Intent(this.context, AlarmReceiver::class.java)
            .also {
                it.putExtra("id", id)
                it.putExtra("title",title)
                it.putExtra("content",content)
            }
    }
}
