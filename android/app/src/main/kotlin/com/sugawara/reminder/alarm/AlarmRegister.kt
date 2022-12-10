package com.sugawara.reminder.alarm

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import com.sugawara.reminder.sqlite.DBHelper
import android.os.Build
import com.sugawara.reminder.alarm.AlarmReceiver

class AlarmRegister(_context: Context) {

    private val context = _context

    @SuppressLint("UnspecifiedImmutableFlag")
    fun registAlarm(
        id: Int,
        title: String,
        content: String,
        time: Long,
        frequency: Long,
    ){
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = createIntent(id, title, content, time, frequency)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            id,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT
        )

        val alarmInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            AlarmManager.AlarmClockInfo(
                time,
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
        time: Long,
        frequency: Long,
    ){
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        val intent = createIntent(id, title, content, time, frequency)
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
        time: Long,
        frequency: Long,
    ): Intent {
        return Intent(this.context, AlarmReceiver::class.java)
            .also {
                it.putExtra(DBHelper.idKey, id)
                it.putExtra(DBHelper.titleKey,title)
                it.putExtra(DBHelper.contentKey,content)
                it.putExtra(DBHelper.timeKey, time)
                it.putExtra(DBHelper.frequencyKey, frequency)
            }
    }
}
