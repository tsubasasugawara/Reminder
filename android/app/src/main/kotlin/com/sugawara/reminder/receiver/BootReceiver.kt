package com.sugawara.reminder.receiver

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.job.JobService
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.sugawara.reminder.MainActivity
import com.sugawara.reminder.R
import com.sugawara.reminder.alarm.AlarmRegister
import com.sugawara.reminder.sqlite.notifications.Notifications
import com.sugawara.reminder.sqlite.notifications.NotificationsHelper
import android.util.Log
import java.time.ZonedDateTime
import java.time.ZoneId
import java.time.Instant

class BootReceiver: BroadcastReceiver() {
    @SuppressLint("UnspecifiedImmutableFlag")
    override fun onReceive(context: Context, intent: Intent) {
        Log.d("BOOT:", "Success Received.");

        val alarmRegisterIntent = Intent(context, AlarmRegister::class.java)
        context.startService(alarmRegisterIntent)
        val notificationsIntent = Intent(context, Notifications::class.java)
        context.startService(notificationsIntent)

        val notifications = Notifications()
        var values = notifications.select(
            context,
            arrayOf(NotificationsHelper.idKey, NotificationsHelper.titleKey, NotificationsHelper.contentKey, NotificationsHelper.timeKey, NotificationsHelper.frequencyKey),
            "${NotificationsHelper.setAlarmKey} == 1",
            null,
            null,
            null,
            null,
            null,
        )

        var register = AlarmRegister(context);
        if (values == null) return
        values.forEach{ v ->
            if (v[NotificationsHelper.idKey] == null) return
            val id = v[NotificationsHelper.idKey] as Int

            if (v[NotificationsHelper.titleKey] == null) return
            val title = v[NotificationsHelper.titleKey].toString()

            val content = v[NotificationsHelper.contentKey].toString()

            if (v[NotificationsHelper.timeKey] == null) return
            val time = v[NotificationsHelper.timeKey] as Long

            val frequency = v[NotificationsHelper.frequencyKey] as? Int ?: 0

            register.registAlarm(id, title, content, time, frequency)
        }
    }
}
