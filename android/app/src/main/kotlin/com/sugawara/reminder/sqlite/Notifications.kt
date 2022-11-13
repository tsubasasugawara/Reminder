package com.sugawara.reminder.sqlite

import android.content.ContentValues
import android.content.Context
import android.database.Cursor
import android.util.Log
import java.lang.Exception

class Notifications {
    /**
     * カーソルからデータを取得
     *
     * @param {cur}: Cursor データベースから取得したCursor
     * @param {columnName}: カラム名
     *
     * @return {res}: Any? IntかStringかNullのデータ
     * */
    private fun getData(
        cur: Cursor,
        columnName: String,
    ): Any? {
        val index: Int = cur.getColumnIndex(columnName)
        if (index < 0) return null

        if (
            columnName == DBHelper.idKey ||
            columnName == DBHelper.frequencyKey ||
            columnName == DBHelper.setAlarmKey ||
            columnName == DBHelper.deletedKey
        ) {
            return cur.getInt(index)
        } else if (
            columnName == DBHelper.timeKey ||
            columnName == DBHelper.createdAtKey ||
            columnName == DBHelper.updatedAtKey
        ) {
            return cur.getLong(index)
        }
         else if (
            columnName == DBHelper.titleKey ||
            columnName == DBHelper.contentKey
        ) {
            return cur.getString(index)
        }
        return null
    }

    /**
     * MapをArray<String>に変換
     *
     * @param {map}: Map<String, String> 変換したいMap
     *
     * @return {res}: Array<String> 変換後のArray
     */
    fun mapToArray(map: Map<String, String>?): Array<String>? {
        if(map == null) return null
        return map.values.toList().toTypedArray()
    }

    /**
     * SELECT文
     *
     * @param {context}:    Context          コンテキスト
     * @param {columns}:    Array<String>    カラム名のリスト
     * @param {where}:      String?          WHERE句
     * @param {whereArgs}:  Array<String>?   WHERE句のプレースホルダに入れる値
     * @param {orderBy}:    String?          並び替え
     * @param {limit}:      Int?             取得する行数
     *
     * @return {res}:       ArrayList<Map<String, Any?>>?  取得したデータ
     * */
    fun select(
        context: Context,
        columns: Array<String>,
        where: String?,
        whereArgs: Array<String>?,
        groupBy: String?,
        having: String?,
        orderBy: String?,
        limit: String?,
    ): ArrayList<Map<String, Any?>>? {
        try {
            val res: ArrayList<Map<String,Any?>> = arrayListOf()
            val dbHelper = DBHelper(context, DBHelper.dbName, null, DBHelper.version);
            val db = dbHelper.readableDatabase

            val cur =
                db.query(
                    DBHelper.tableName,
                    columns,
                    where,
                    whereArgs,
                    groupBy,
                    having,
                    orderBy,
                    limit
                )
            if (cur.count > 0) {
                cur.moveToFirst()
                while (!cur.isAfterLast) {
                    var idIndex         = cur.getColumnIndex(DBHelper.idKey)
                    var titleIndex      = cur.getColumnIndex(DBHelper.titleKey)
                    var contentIndex    = cur.getColumnIndex(DBHelper.contentKey)
                    var frequencyIndex  = cur.getColumnIndex(DBHelper.frequencyKey)
                    var timeIndex       = cur.getColumnIndex(DBHelper.timeKey)
                    var setAlarmIndex   = cur.getColumnIndex(DBHelper.setAlarmKey)
                    var deletedIndex    = cur.getColumnIndex(DBHelper.deletedKey)
                    var createdAtIndex  = cur.getColumnIndex(DBHelper.createdAtKey)
                    var updatedAtIndex  = cur.getColumnIndex(DBHelper.updatedAtKey)

                    var id:             Int?    = null
                    var title:          String? = null
                    var content:        String? = null
                    var frequency:      Int?    = null
                    var time:           Long?   = null
                    var setAlarm:       Int?    = null
                    var deleted:        Int?    = null
                    var createdAt:      Long?   = null
                    var updatedAt:      Long?   = null

                    if (idIndex >= 0) {
                        id = cur.getInt(idIndex)
                    }
                    if (titleIndex >= 0) {
                        title = cur.getString(titleIndex)
                    }
                    if (contentIndex >= 0) {
                        content = cur.getString(contentIndex)
                    }
                    if (frequencyIndex >= 0) {
                        frequency = cur.getInt(frequencyIndex)
                    }
                    if (timeIndex >= 0) {
                        time = cur.getLong(timeIndex)
                    }
                    if (setAlarmIndex >= 0) {
                        setAlarm = cur.getInt(setAlarmIndex)
                    }
                    if (deletedIndex >= 0) {
                        deleted = cur.getInt(deletedIndex)
                    }
                    if (createdAtIndex >= 0) {
                        createdAt = cur.getLong(createdAtIndex)
                    }
                    if (updatedAtIndex >= 0) {
                        updatedAt = cur.getLong(updatedAtIndex)
                    }

                    res.add(
                        mapOf(
                            "id"            to id,
                            "title"         to title,
                            "content"       to content,
                            "frequency"     to frequency,
                            "time"          to time,
                            "setAlarm"      to setAlarm,
                            "deleted"       to deleted,
                            "createdAtKey"  to createdAt,
                            "updatedAtKey"  to updatedAt,
                        )
                    )
                    cur.moveToNext()
                }
            }
            db.close()
            return res
        } catch (e: Exception) {
            Log.e("select data", e.toString())
            return null
        }
    }

    /**
     * INSERT文
     *
     * @param {context}: Context
     * @param {values}: ContentValues? 挿入したいデータ(Notificationsにあるカラムを全て定義)
     *
     * @return {num}: Long 挿入した行のID。挿入できなかった場合は-1
     * */
    fun insert(
        context: Context,
        values: ContentValues?,
    ): Long {
        try {
            val dbHelper = DBHelper(context, DBHelper.dbName, null, DBHelper.version);
            val db = dbHelper.readableDatabase
            val num = db.insert(DBHelper.dbName, null, values)
            db.close()
            return num
        } catch (e: Exception) {
            Log.e("insert data", e.toString())
            return -1
        }
    }

    /**
     * UPDATE文
     *
     * @param {context}: Context
     * @param {values}: ContentValues? 更新するデータ
     * @param {whereClause}: String? WHERE句
     * @param {whereArgs}: Array<String?>? WHERE句のプレースホルダに入れる値
     *
     * @return {num}: Int 更新した行数
     * */
    fun update(
        context: Context,
        values: ContentValues?,
        whereClause: String?,
        whereArgs: Array<String>?,
    ): Int {
        try {
            val dbHelper = DBHelper(context, DBHelper.dbName, null, DBHelper.version)
            val db = dbHelper.readableDatabase
            val num = db.update(DBHelper.tableName, values, whereClause, whereArgs)
            db.close()
            return num
        } catch (e: Exception) {
            Log.e("update data", e.toString())
            return -1
        }
    }

    /**
     * DELETE文
     *
     * @param {context}: Context
     * @param {whereClause}: String? WHERE句
     * @param {whereArgs}: Array<String?>? WHERE句のプレースホルダに入れる値
     *
     * @return {num}: Int 削除した行数
     * */
    fun delete(
        context: Context,
        whereClause: String?,
        whereArgs: Array<String>?,
    ): Int {
        try {
            val dbHelper = DBHelper(context, DBHelper.dbName, null, DBHelper.version)
            val db = dbHelper.readableDatabase
            val num = db.delete(DBHelper.tableName, whereClause, whereArgs)
            db.close()
            return num
        } catch (e: Exception) {
            Log.e("delete data", e.toString())
            return -1
        }
    }
}
