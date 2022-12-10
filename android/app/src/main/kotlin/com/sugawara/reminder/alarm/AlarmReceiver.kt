package com.sugawara.reminder.alarm

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.job.JobService
import android.content.BroadcastReceiver
import android.content.Context
import android.content.ContentValues
import android.content.Intent
import com.sugawara.reminder.MainActivity
import com.sugawara.reminder.R
import com.sugawara.reminder.alarm.AlarmRegister
import com.sugawara.reminder.sqlite.Notifications
import com.sugawara.reminder.sqlite.DBHelper
import android.util.Log
import java.time.ZonedDateTime
import java.time.ZoneId
import java.time.Instant

class AlarmReceiver: BroadcastReceiver() {

    companion object {
        const val CHANNEL_ID = "com.sugawara.reminder"
        const val NOT_REPEAT:   Long = 0
        const val ONE_DAY:      Long = -1
        const val ONE_WEEK:     Long = -2
        const val ONE_MONTH:    Long = -3
        const val ONE_YEAR:     Long = -4
    }

    @SuppressLint("UnspecifiedImmutableFlag")
    override fun onReceive(context: Context, intent: Intent) {
        // if(Intent.ACTION_LOCKED_BOOT_COMPLETED.equals(intent.getAction())) {
        //     val id = intent.extras?.getInt("id") ?: return
        //     val title = intent.extras?.getString("title") ?: return
        //     val content = intent.extras?.getString("content") ?: return
        //     val time = intent.extras?.getLong("time") ?: return

        //     val serviceIntent = Intent(context, AlarmRegister::class.java)
        //     context.startService(serviceIntent)

        //     val register = AlarmRegister(context)
        //     register.registAlarm(id, title, content, time)

        //     return
        // }

        //if(intent.getAction().equals(Intent.ACTION_BOOT_COMPLETED)) {
        //    Intent(context, MainActivity::class.java).apply {
        //        flags = Intent.FLAG_ACTIVITY_NEW_TASK
        //        context?.startActivity(this)
        //    }
        //}

        //Log.d("INTENT", intent.toString())

        this.createNotificationChannel(context)
        this.createNotification(context, intent)
    }

    private fun createNotificationChannel(context: Context) {
        val name = "リマインダー"
        val descriptionText = "リマインダーの通知"
        val importance = NotificationManager.IMPORTANCE_HIGH

        val channel = NotificationChannel(
            AlarmReceiver.CHANNEL_ID,
            name,
            importance
        ).apply {
            description = descriptionText
        }.also {
            it.enableLights(true)
            it.enableVibration(true)
        }

        val notificationManager: NotificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        notificationManager.createNotificationChannel(channel)
    }

    @SuppressLint("UnspecifiedImmutableFlag")
    private fun createNotification(context: Context, intent: Intent) {
        val id = intent.extras?.getInt("id") ?: return
        val title = intent.extras?.getString("title") ?: return
        val content = intent.extras?.getString("content") ?: return

        val activityIntent = Intent(context, MainActivity::class.java)

        val pendingIntent = PendingIntent.getActivity(
            context,
            0,
            activityIntent.apply {
                this.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            },
            PendingIntent.FLAG_UPDATE_CURRENT
        )

        val builder = Notification.Builder(context, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(content)
            .setSmallIcon(R.mipmap.ic_stat_push_icon)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setVisibility(Notification.VISIBILITY_PUBLIC)

        val manager = context.getSystemService(JobService.NOTIFICATION_SERVICE) as NotificationManager

        manager.notify(id, builder.build())
    }

    private fun reRegistAlarm(context: Context, intent: Intent) {
        val id = intent.extras?.getInt("id") ?: return
        val title = intent.extras?.getString("title") ?: return
        val content = intent.extras?.getString("content") ?: return
        val time = intent.extras?.getLong("time") ?: return
        val frequency = intent.extras?.getLong("frequency") ?: return

        // 繰り返さない場合は処理を終了
        if (frequency == AlarmReceiver.NOT_REPEAT) return

        val zonedDt = ZonedDateTime.ofInstant(
            Instant.ofEpochMilli(time),
            ZoneId.systemDefault()
        )
        // 次にアラームを発火する日時を計算する
        var nextDateTime: Long
        when(frequency) {
            AlarmReceiver.ONE_DAY -> nextDateTime = zonedDt.plusDays(1).toInstant().toEpochMilli()
            AlarmReceiver.ONE_WEEK -> nextDateTime = zonedDt.plusWeeks(1).toInstant().toEpochMilli()
            AlarmReceiver.ONE_MONTH -> nextDateTime = zonedDt.plusMonths(1).toInstant().toEpochMilli()
            AlarmReceiver.ONE_YEAR -> nextDateTime = zonedDt.plusYears(1).toInstant().toEpochMilli()
            else -> nextDateTime = zonedDt.plusDays(frequency).toInstant().toEpochMilli()
        }

        // アラームを登録する
        val alarmRegisterIntent = Intent(context, AlarmRegister::class.java)
        context.startService(alarmRegisterIntent)
        val register = AlarmRegister(context)
        register.registAlarm(id, title, content, nextDateTime, frequency)

        // アラーム発火時間を更新する
        val notificationsIntent = Intent(context, Notifications::class.java)
        context.startService(notificationsIntent)
        val notifications = Notifications()
        var values = ContentValues()
        values.put(DBHelper.timeKey, nextDateTime)
        notifications.update(context,values,"id = ?",arrayOf(id.toString()))
    }
}
