    package com.sugawara.reminder.sqlite

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class DBHelper(context: Context, databaseName:String, factory: SQLiteDatabase.CursorFactory?, version: Int,) : SQLiteOpenHelper(context, databaseName, factory, version) {

    // TODO: contentが常に内容があるわけではないため、正規化の必要性あり
    companion object {
        const val version:      Int = 1
        const val dbName:       String = "notifications"
        const val tableName:    String = "notifications"
        const val idKey:        String = "id"
        const val titleKey:     String = "title"
        const val contentKey:   String = "content"
        const val frequencyKey: String = "frequency"
        const val timeKey:      String = "time"
        const val setAlarmKey:  String = "set_alarm"
        const val deletedKey:   String = "deleted"
        const val createdAtKey: String = "created_at"
        const val updatedAtKey: String = "updated_at"
    }

    override fun onCreate(db: SQLiteDatabase?) {
        db?.execSQL("""
            CREATE TABLE IF NOT EXISTS $tableName (
              $idKey INTEGER PRIMARY KEY AUTOINCREMENT not null,
              $titleKey TEXT not null,
              $contentKey TEXT,
              $frequencyKey INTEGER,
              $timeKey INTEGER not null,
              $setAlarmKey INTEGER not null,
              $deletedKey INTEGER not null DEFAULT 0,
              $createdAtKey INTEGER not null,
              $updatedAtKey INTEGER not null)
        """.trimIndent())
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        if (oldVersion >= newVersion) return

        // if (oldVersion == 1) {
        //     db?.execSQL(
        //         """
        //         ALTER TABLE $tableName ADD COLUMN $deletedKey INTEGER not null DEFAULT 0
        //     """.trimIndent()
        //     )
        // }
    }


}
