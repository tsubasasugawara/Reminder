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
    }

    private val NOT_REPEAT:   Int = 0
    private val ONE_DAY:      Int = -1
    private val ONE_WEEK:     Int = -2
    private val ONE_MONTH:    Int = -3
    private val ONE_YEAR:     Int = -4

    @SuppressLint("UnspecifiedImmutableFlag")
    override fun onReceive(context: Context, intent: Intent) {
        this.createNotificationChannel(context)
        this.createNotification(context, intent)
        this.reRegistAlarm(context, intent)
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
        val id = intent.extras?.getInt(DBHelper.idKey) ?: return
        val title = intent.extras?.getString(DBHelper.titleKey) ?: return
        val content = intent.extras?.getString(DBHelper.contentKey) ?: return

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

    //TODO: 再登録時の時間変更がうまくされていない可能性がある。
    private fun reRegistAlarm(context: Context, intent: Intent) {
        val id = intent.extras?.getInt(DBHelper.idKey) ?: return
        val title = intent.extras?.getString(DBHelper.titleKey) ?: return
        val content = intent.extras?.getString(DBHelper.contentKey) ?: return
        val time = intent.extras?.getLong(DBHelper.timeKey) ?: return
        val frequency = intent.extras?.getInt(DBHelper.frequencyKey) ?: return

        // 繰り返さない場合は処理を終了
        if (frequency == NOT_REPEAT) return

        val zonedDt = ZonedDateTime.ofInstant(
            Instant.ofEpochMilli(time),
            ZoneId.systemDefault()
        )
        // 次にアラームを発火する日時を計算する
        var nextDateTime: Long
        if (frequency == ONE_DAY)
            nextDateTime = zonedDt.plusDays(1).toInstant().toEpochMilli()
        else if (frequency == ONE_WEEK)
            nextDateTime = zonedDt.plusWeeks(1).toInstant().toEpochMilli()
        else if (frequency == ONE_MONTH)
            nextDateTime = zonedDt.plusMonths(1).toInstant().toEpochMilli()
        else if (frequency == ONE_YEAR)
            nextDateTime = zonedDt.plusYears(1).toInstant().toEpochMilli()
        else if (frequency > 0)
            nextDateTime = zonedDt.plusDays(frequency.toLong()).toInstant().toEpochMilli()
        else
            return

        // アラーム発火時間を更新する
        val notificationsIntent = Intent(context, Notifications::class.java)
        context.startService(notificationsIntent)
        val notifications = Notifications()
        var values = ContentValues()
        values.put(DBHelper.timeKey, nextDateTime)
        notifications.update(context,values,"${DBHelper.idKey} = ?",arrayOf(id.toString()))

        // アラームを登録する
        val alarmRegisterIntent = Intent(context, AlarmRegister::class.java)
        context.startService(alarmRegisterIntent)
        val register = AlarmRegister(context)
        register.registAlarm(id, title, content, nextDateTime, frequency)
    }
}
