package com.sugawara.reminder.sqlite.tags

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import com.sugawara.reminder.sqlite.DBEnv

class TagsHelper(
    context: Context,
    databaseName:String,
    factory: SQLiteDatabase.CursorFactory?,
    version: Int,
) : SQLiteOpenHelper(context, databaseName, factory, version) {

    companion object {
        const val version:      Int = 1
        const val tableName:    String = "tags"

        const val idKey:        String = "tag_id"
        const val tagKey:       String = "tag"
        const val createdAtKey: String = DBEnv.createdAtKey
        const val updatedAtKey: String = DBEnv.updatedAtKey
    }

    override fun onCreate(db: SQLiteDatabase?) {
        db?.execSQL("""
            CREATE TABLE IF NOT EXISTS $tableName (
              $idKey INTEGER PRIMARY KEY AUTOINCREMENT not null,
              $tagKey TEXT not null,
              $createdAtKey INTEGER not null,
              $updatedAtKey INTEGER not null)
        """.trimIndent())
    }

    override fun onUpgrade(db: SQLiteDatabase?, oldVersion: Int, newVersion: Int) {
        if (oldVersion >= newVersion) return
    }


}
