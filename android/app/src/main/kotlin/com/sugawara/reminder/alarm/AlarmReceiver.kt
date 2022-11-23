package com.sugawara.reminder.alarm

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
import android.util.Log

class AlarmReceiver: BroadcastReceiver() {

    companion object {
        const val CHANNEL_ID = "com.sugawara.reminder"
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
            "com.sugawara.reminder",
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
}
