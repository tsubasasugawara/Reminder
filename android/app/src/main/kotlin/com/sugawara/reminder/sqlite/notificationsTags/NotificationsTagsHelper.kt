package com.sugawara.reminder.sqlite.notificationsTags

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.sugawara.reminder.sqlite.DBEnv
import com.sugawara.reminder.sqlite.tags.TagsHelper
import com.sugawara.reminder.sqlite.notifications.NotificationsHelper

class NotificationsTagsHelper(
    context: Context,
    databaseName:String,
    factory: SQLiteDatabase.CursorFactory?,
    version: Int,
) : SQLiteOpenHelper(context, databaseName, factory, version) {

    companion object {
        const val version:      Int = 1
        const val tableName:    String = "notifications_tags"

        const val idKey:                    String = "notification_tag_id"
        const val tagIdKey:                 String = TagsHelper.idKey
        const val notificationIdKey:       String = NotificationsHelper.idKey
        const val createdAtKey:             String = DBEnv.createdAtKey
        const val updatedAtKey:             String = DBEnv.updatedAtKey
    }

    override fun onCreate(db: SQLiteDatabase?) {
        db?.execSQL("""
            CREATE TABLE IF NOT EXISTS $tableName (
              $idKey INTEGER PRIMARY KEY AUTOINCREMENT not null,
              $tagIdKey INTEGER not null,
              $notificationIdKey INTEGER not null,
              $createdAtKey INTEGER not null,
              $updatedAtKey INTEGER not null)
        """.trimIndent())
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        if (oldVersion >= newVersion) return
    }


}
